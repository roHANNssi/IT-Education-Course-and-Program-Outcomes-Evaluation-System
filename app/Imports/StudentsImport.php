<?php

namespace App\Imports;

use App\Models\Student;
use App\Models\Enrollment;
use App\Models\EnrolledSubject;
use App\Models\FacultySubject;
use App\Models\User;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Concerns\ToModel;
use Maatwebsite\Excel\Concerns\ToCollection;
use Maatwebsite\Excel\Concerns\WithHeadingRow;

class StudentsImport implements ToCollection
{
    protected $facultySubjectId;

    public function __construct($facultySubjectId)
    {
        $this->facultySubjectId = $facultySubjectId;
    }

    protected static function parseFullName($fullName)
    {
        $lastName = '';
        $firstName = '';
        $middleName = '';
        $nameExt = '';

        // Split by comma first → [Lastname] , [Firstname + MI + Ext]
        $parts = explode(',', $fullName);

        if (count($parts) >= 2) {
            $lastName = trim($parts[0]);
            $rest = trim($parts[1]);

            // Break the rest by spaces
            $nameParts = explode(' ', $rest);

            $firstName = array_shift($nameParts); // first word = firstname

            // Remaining could be MI + Ext
            foreach ($nameParts as $part) {
                $part = trim($part);

                if (in_array(strtolower($part), ['jr.', 'sr.', 'ii', 'iii', 'iv'])) {
                    $nameExt = $part;
                } elseif (preg_match('/^[A-Z]\.?$/', $part)) {
                    $middleName = $part; // middle initial
                } else {
                    // if not MI or ext, treat as part of first name (like "Juan Carlos")
                    $firstName .= ' ' . $part;
                }
            }
        } else {
            // If no comma, fallback: split by space
            $tokens = explode(' ', $fullName);
            $lastName = array_pop($tokens);
            $firstName = implode(' ', $tokens);
        }

        return [$lastName, $firstName, $middleName, $nameExt];
    }

    public function collection(Collection $rows)
    {
        $faculty_subject = FacultySubject::select(
                'faculty_subjects.*',
                'subjects.course_major_id',
                'subjects.yr_level'
            )
            ->join('subjects', 'subjects.id', 'faculty_subjects.subject_id')
            ->where('faculty_subjects.id', $this->facultySubjectId)
            ->first();

        $course_major_id = $faculty_subject->course_major_id ?? null;
        $semester_id     = $faculty_subject->semester_id ?? null;
        $section         = $faculty_subject->section ?? null;
        $yr_level        = $faculty_subject->yr_level ?? null;

        // 1. Preload all Students by id_number
        $idNumbers = $rows->skip(1)->pluck(0)->map(fn($v) => trim($v))->filter()->unique();
        $students = Student::with('user')->whereIn('id_number', $idNumbers)->get();
        $studentsByIdNumber = $students->keyBy('id_number');

        // 2. Preload all Enrollments for these students
        $studentIds = $students->pluck('id');
        $enrollments = Enrollment::whereIn('student_id', $studentIds)
            ->where('semester_id', $semester_id)
            ->where('year_level', $yr_level)
            ->where('section', $section)
            // ->where('course_major_id', $course_major_id)
            ->get();

        $enrollmentsByKey = $enrollments->mapWithKeys(function ($enr) {
            $key = $enr->student_id.'-'.$enr->semester_id.'-'.$enr->year_level.'-'.$enr->section;
            return [$key => $enr];
        });

        // 3. Preload EnrolledSubjects
        $enrolledSubjects = EnrolledSubject::where('faculty_subject_id', $this->facultySubjectId)
            ->whereIn('enrollment_id', $enrollments->pluck('id'))
            ->get();

        $enrolledByEnrollment = $enrolledSubjects->pluck('id', 'enrollment_id');

        DB::transaction(function () use ($rows, $semester_id, $yr_level, $section, $course_major_id, &$studentsByIdNumber, &$enrollmentsByKey, &$enrolledByEnrollment) {
            foreach ($rows->skip(1) as $row) {
                $idNumber = trim($row[0] ?? '');
                $fullName = trim($row[1] ?? '');
                $gender   = trim($row[2] ?? '');
                // $email    = trim($row[3] ?? '');
                $email    = trim($row[3] ?? '') ?: strtolower($idNumber) . '@marsu.edu.ph';

                if (!$idNumber || !$fullName) continue;

                // Student base check
                $student = $studentsByIdNumber[$idNumber] ?? null;

                if (!$student) {
                    [$lastName, $firstName, $middleName, $nameExt] = self::parseFullName($fullName);
                    $gender_initial = $gender === 'M' ? 'male' : 'female';

                    // If email is empty, generate institutional one
                    $email = trim($email) ?: strtolower($idNumber) . '@marsu.edu.ph';

                    // Ensure email is unique
                    $baseEmail = $email;
                    $counter = 1;
                    while (User::where('email', $email)->exists()) {
                        $email = preg_replace('/@.*/', '', $baseEmail) . $counter . '@marsu.edu.ph';
                        $counter++;
                    }

                    // Ensure ID number is unique
                    $originalIdNumber = $idNumber;
                    $counter = 1;
                    while (Student::where('id_number', $idNumber)->exists()) {
                        $idNumber = $originalIdNumber . '_' . $counter;
                        $counter++;
                    }

                    // Create the user
                    $user = User::create([
                        'name'       => $fullName,
                        'email'      => $email,
                        'role'       => 'student',
                        'last_name'  => $lastName,
                        'first_name' => $firstName,
                        'mid_name'   => $middleName,
                        'name_ext'   => $nameExt,
                        'gender'     => $gender_initial,
                        'password'   => bcrypt($originalIdNumber),
                    ]);

                    // Create the student
                    $student = Student::create([
                        'id_number' => $idNumber,
                        'user_id'   => $user->id,
                        'college_id'=> 10,
                        'course_id' => null,
                    ]);

                    // Cache for subsequent iterations
                    $studentsByIdNumber[$originalIdNumber] = $student;
                }

                // Enrollment check
                $enrollKey = $student->id.'-'.$semester_id.'-'.$yr_level.'-'.$section;
                $enrollment = $enrollmentsByKey[$enrollKey] ?? null;

                if (!$enrollment) {
                    $enrollment = Enrollment::create([
                        'student_id'     => $student->id,
                        'semester_id'    => $semester_id,
                        'year_level'     => $yr_level,
                        'section'        => $section,
                        'course_major_id'=> $course_major_id,
                    ]);

                    $enrollmentsByKey[$enrollKey] = $enrollment; // cache
                }

                // EnrolledSubject check
                if (!isset($enrolledByEnrollment[$enrollment->id])) {
                    $enrolled = EnrolledSubject::create([
                        'faculty_subject_id' => $this->facultySubjectId,
                        'enrollment_id'      => $enrollment->id,
                    ]);

                    $enrolledByEnrollment[$enrollment->id] = $enrolled->id; // cache
                }
            }
        });
    }

}
