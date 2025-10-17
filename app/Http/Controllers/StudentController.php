<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;
use App\Models\Enrollment;
use App\Models\EnrolledSubject;
use App\Models\FacultySubject;
use App\Models\Student;
use App\Imports\StudentsImport;
use Maatwebsite\Excel\Facades\Excel;

class StudentController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $faculty_subject_id = $request->faculty_subject_id;

        $faculty_subject = FacultySubject::select('faculty_subjects.*', 'semesters.sem', 'semesters.acad_year', 'subjects.subject_code', 'subjects.subject_title')
            ->join('semesters', 'semesters.id', 'faculty_subjects.semester_id')
            ->join('subjects', 'subjects.id', 'faculty_subjects.subject_id')
            ->where('faculty_subjects.id', $faculty_subject_id)
            ->first();

        $enrolled_subjects = EnrolledSubject::select('enrolled_subjects.*', 'enrollments.year_level', 'enrollments.section', 'students.id_number', 'users.last_name', 'users.first_name', 'users.mid_name', 'users.name_ext', 'users.gender')
            ->join('enrollments', 'enrollments.id', 'enrolled_subjects.enrollment_id')
            ->join('students', 'students.id', 'enrollments.student_id')
            ->join('users', 'users.id', 'students.user_id')
            ->where('enrolled_subjects.faculty_subject_id', $faculty_subject_id)
            ->get();

        return Inertia::render('Management/StudentList', [
            'faculty_subject_id' => $faculty_subject_id,
            'faculty_subject' => $faculty_subject,
            'enrolled_subjects' => $enrolled_subjects,
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'faculty_subject_id' => 'required|exists:faculty_subjects,id',
            'csv_file' => 'required|file|mimes:csv,txt,xlsx,xls',
        ]);

         Excel::import(new StudentsImport($request->faculty_subject_id), $request->file('csv_file'));

        return back()->with('success', 'Students imported successfully!');
    }

    public function verifyIDNumber(Request $request)
    {
        $request->validate([
            'id_number' => 'required|string|max:50',
        ]);

        $student = Student::select('users.email', 'users.last_name', 'users.first_name', 'users.mid_name', 'users.name_ext')->join('users', 'users.id', 'students.user_id')->where('id_number', $request->id_number)->first();

        if (!$student) {
            return response()->json([
                'success' => false,
                'message' => 'ID Number not found.',
            ], 422);
        }

        return response()->json([
            'success' => true,
            'student' => $student->only(['last_name', 'first_name', 'mid_name', 'name_ext', 'email']),
        ]);
    }
}
