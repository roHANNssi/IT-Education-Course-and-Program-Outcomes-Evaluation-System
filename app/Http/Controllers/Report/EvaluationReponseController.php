<?php

namespace App\Http\Controllers\Report;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use Inertia\Inertia;
use App\Models\Course;
use App\Models\Curriculum;
use App\Models\Faculty;
use App\Models\Semester;
use App\Models\Student;
use App\Models\Subject;

class EvaluationReponseController extends Controller
{
    public function index()
    {
        $user_id = Auth::user()->id ?? null;
        $designation = Auth::user()->facultyUser->designation ?? null;
        $course_id = Auth::user()->facultyUser->course_id ?? null;

        $faculties = Faculty::select('faculties.course_id')->where('faculties.user_id', $user_id)->where('faculties.designation', $designation)->groupBy('faculties.course_id')->get();
        $program_ids = [];
        if ($designation=='program-head' && !empty($faculties)) {
            foreach ($faculties as $faculty) {
                $program_ids[] = $faculty->course_id;
            }
        }

        $qry_courses = Course::select('courses.*')
            ->with('curricula');
        if (!empty($program_ids)) {
            $qry_courses->whereIn('courses.id', $program_ids);
        }
        $programs = $qry_courses->get();

        return Inertia::render('Report/EvaluationResponse/Index', [
            'programs' => $programs
        ]);
    }

    public function show(Request $request, $curriculum_id)
    {
        $_curriculum = new Curriculum;
        $_subject = new Subject;

        $user_id = Auth::user()->id ?? null;
        $designation = Auth::user()->facultyUser->designation ?? null;

        $semester = Semester::where('status', 'active')->first();
        $current_sem_id = $semester->id ?? null;
        $semester_id = $request->semester_id ?? $current_sem_id;
        $yr_level = $request->yr_level ?? 'first';

        $faculties = Faculty::select('faculties.semester_id')->where('faculties.user_id', $user_id)->where('faculties.designation', $designation)->groupBy('faculties.semester_id')->get();
        $semester_ids = [];
        if (!empty($faculties)) {
            foreach ($faculties as $faculty) {
                $semester_ids[] = $faculty->semester_id;
            }
        }

        $qry_sems = Semester::orderBy('semesters.order_num', 'DESC');
        if (!empty($semester_ids)) {
            $qry_sems->whereIn('semesters.id', $semester_ids);
        }
        $semesters = $qry_sems->get();

        $curriculum = $_curriculum->getCurriculum($curriculum_id);
        $course_id = $curriculum->course_id ?? null;

        $subjects = Subject::select('subjects.*', 'course_majors.course_major')
            ->with(['faculty_subjects' => function ($faculty_subjects) {
                $faculty_subjects->select('faculty_subjects.subject_id', 'enrollments.student_id')
                    ->join('enrolled_subjects', 'enrolled_subjects.faculty_subject_id', 'faculty_subjects.id')
                    ->join('enrollments', 'enrollments.id', 'enrolled_subjects.enrollment_id')
                    ->groupBy('faculty_subjects.subject_id')
                    ->groupBy('enrollments.student_id');
            }, 'evaluations' => function ($evaluations) {
                $evaluations->select('subject_id', 'student_id')->groupBy('subject_id')->groupBy('student_id');
            }])
            ->leftJoin('course_majors', 'course_majors.id', 'subjects.course_major_id')
            ->where('subjects.curriculum_id', $curriculum_id)
            ->where('subjects.yr_level', $yr_level)
            ->orderBy('subjects.subject_title', 'ASC')
            ->get();

        return Inertia::render('Report/EvaluationResponse/Show', [
            'curriculum_id' => $curriculum_id,
            'semester_id' => $semester_id,
            'yr_level' => $yr_level,
            'semesters' => $semesters,
            'curriculum' => $curriculum,
            'subjects' => $subjects,
        ]);
    }
}
