<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;
use App\Models\Enrollment;
use App\Models\EvaluationSchedule;
use App\Models\Student;
use Carbon\Carbon;

class DashboardController extends Controller
{
    public function index()
    {
        $today = Carbon::today();

        // If role is student
        if (Auth::user()->role=='student') {
            $student = Student::select('students.*', 'courses.course_name', 'courses.course_code')->where('students.user_id', Auth::user()->id)->leftJoin('courses', 'courses.id', 'students.course_id')->first();

            $activeSchedule = EvaluationSchedule::where('course_id', $student->course_id)
                ->whereDate('start_date', '<=', $today)
                ->whereDate('end_date', '>=', $today)
                ->latest('start_date')
                ->first();

            $enrollments = Enrollment::select('enrollments.*', 'semesters.sem', 'semesters.acad_year', 'course_majors.course_major', 'evaluation_schedules.start_date', 'evaluation_schedules.end_date')
                ->with(['enrolled_subjects' => function ($enrolled_subjects) {
                    $enrolled_subjects->select('enrolled_subjects.id', 'enrolled_subjects.enrollment_id', 'enrolled_subjects.faculty_subject_id')
                        ->with(['evaluation' => function ($evaluation) {
                            $evaluation->select('evaluations.semester_id', 'evaluations.enrolled_subject_id')
                            ->groupBy('evaluations.semester_id')
                            ->groupBy('evaluations.enrolled_subject_id');
                        }]);
                }])
                ->join('students', 'students.id', 'enrollments.student_id')
                ->join('semesters', 'semesters.id', 'enrollments.semester_id')
                ->leftJoin('course_majors', 'course_majors.id', 'enrollments.course_major_id')
                ->leftJoin('evaluation_schedules', 'evaluation_schedules.semester_id', 'semesters.id')
                ->where('enrollments.student_id', $student->id)
                ->orderBy('semesters.order_num', 'DESC')
                ->get();
            
            $data_enrollments = [];
            if (!empty($enrollments)) {
                foreach ($enrollments as $enrollment) {
                    $es_count = 0;
                    $ev_count = 0;
                    if (!empty($enrollment->enrolled_subjects)) {
                        foreach ($enrollment->enrolled_subjects as $enrolled_subject) {
                            if ($enrolled_subject->evaluation!=null && $enrolled_subject->evaluation->enrolled_subject_id==$enrolled_subject->id) {
                                $ev_count++;
                            }
                            $es_count++;
                        }
                    }
                    $data_en = [
                        'id' => $enrollment->id,
                        'sem' => $enrollment->sem,
                        'acad_year' => $enrollment->acad_year,
                        'year_level' => $enrollment->year_level,
                        'start_date' => $enrollment->start_date,
                        'end_date' => $enrollment->end_date,
                        'es_count' => $es_count,
                        'ev_count' => $ev_count,
                    ];
                    array_push($data_enrollments, $data_en);
                }
            }
            $data_enrollments;

            return Inertia::render('Student/Dashboard', [
                'data_enrollments' => $data_enrollments,
                'active_schedule' => $activeSchedule,
            ]);

        } else {
            
            return Inertia::render('DashboardAdmin');
        }
    }
}
