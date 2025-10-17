<?php

namespace App\Http\Controllers\Report;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;
use App\Models\Course;
use App\Models\Faculty;
use App\Models\ProgramOutcome;
use App\Models\Semester;
use Barryvdh\DomPDF\Facade\Pdf;

class POAssessmentResultController extends Controller
{
    public function index(Request $request)
    {
        $user_id = Auth::user()->id ?? null;
        $designation = Auth::user()->facultyUser->designation ?? null;

        $semester = Semester::where('status', 'active')->first();
        $current_sem_id = $semester->id ?? null;
        
        $semester_id = $request->input('semester_id') ?? $current_sem_id;
        $course_id = $request->input('course_id') ?? 2;

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

        $courses = Course::all();

        $report = ProgramOutcome::generateAssessmentReport($semester_id, $course_id);

        return Inertia::render('Report/POAssessmentResult', [
            'semester_id' => $semester_id,
            'course_id' => $course_id,
            'semesters' => $semesters,
            'courses' => $courses,
            'report' => $report,
        ]);
    }

    public function exportPDF(Request $request)
    {
        $reportData = $request->input('report', []);
        $courseName = $request->input('course_name', 'N/A');
        $semester = $request->input('semester_name', 'N/A');

        $pdf = Pdf::loadView('reports.po_assessment_result_pdf', [
            'report' => $reportData,
            'courseName' => $courseName,
            'semester' => $semester,
        ])->setPaper('a4', 'portrait');

        return $pdf->download('Program_Outcome_Assessment_Report.pdf');
    }
}
