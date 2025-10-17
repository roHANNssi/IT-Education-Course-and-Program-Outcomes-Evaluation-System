<?php

namespace App\Http\Controllers\Student;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\Enrollment;
use App\Models\EnrolledSubject;
use App\Models\Evaluation;
use App\Models\EvaluationComment;
use App\Models\EvaluationSchedule;
use App\Models\Scale;
use App\Models\Subject;
use Carbon\Carbon;
use Inertia\Inertia;

class EvaluationController extends Controller
{
    public function create($enrollment_id)
    {
        $_enrollment = new Enrollment;

        $enrollment = $_enrollment->getEnrollment($enrollment_id);
        $semester_id = $enrollment->semester_id ?? null;
        
        // Check if an active evaluation schedule exists for this student's course and semester
        $today = Carbon::today();

        $activeSchedule = EvaluationSchedule::where('course_id', $enrollment->student->course_id)
        ->where('semester_id', $semester_id)
        ->whereDate('start_date', '<=', $today)
        ->whereDate('end_date', '>=', $today)
        ->first();

        // No active schedule? redirect back to dashboard with a flash message
        if (!$activeSchedule) {
            return redirect()
                ->route('dashboard')
                ->with('error', 'Evaluation is currently closed for your course and semester.');
        }

        $subjects = Subject::select('subjects.id', 'subjects.subject_code', 'subjects.subject_title', 'enrolled_subjects.id as enrolled_subject_id', 'enrolled_subjects.enrollment_id', 'enrolled_subjects.faculty_subject_id', 'course_majors.course_major')
            ->with(['rating_setting' => function ($rating_setting) {
                $rating_setting->select('id', 'subject_id', 'scale_version', 'co_version');
            }, 'course_outcomes' => function ($course_outcomes) {
                $course_outcomes->select('id', 'subject_id', 'version', 'order_no', 'course_outcome')
                    ->with(['outcome_links' => function ($outcome_links) {
                        $outcome_links->select('course_outcome_id', 'program_outcome_id', 'program_outcomes.po_code')->join('program_outcomes', 'program_outcomes.id', 'outcome_links.program_outcome_id')->orderBy('program_outcomes.order_number');
                    }])
                    ->orderBy('course_outcomes.order_no','ASC');
            }])
            ->join('faculty_subjects', 'faculty_subjects.subject_id', 'subjects.id')
            ->join('enrolled_subjects', 'enrolled_subjects.faculty_subject_id', 'faculty_subjects.id')
            ->leftJoin('course_majors', 'course_majors.id', 'subjects.course_major_id')
            ->where('enrolled_subjects.enrollment_id', $enrollment_id)
            ->orderBy('subjects.subject_title', 'ASC')
            ->get();

        $scales = Scale::orderBy('scales.version', 'DESC')->orderBy('scales.rating', 'DESC')->get();

        return Inertia::render('Student/EvaluateForm', [
            'enrollment_id' => $enrollment_id,
            'enrollment' => $enrollment,
            'subjects' => $subjects,
            'scales' => $scales,
            'active_schedule' => $activeSchedule,
        ]);
    }

    public function store(Request $request)
    {
        // return $request;
        $validated = $request->validate([
            'enrollment_id' => 'required|exists:enrollments,id',
            'evaluations'   => 'required|array|min:1',
            'evaluations.*.subject_id' => 'required|exists:subjects,id',
            'evaluations.*.enrolled_subject_id' => 'required|exists:enrolled_subjects,id',
            'evaluations.*.course_outcome_id' => 'required|exists:course_outcomes,id',
            'evaluations.*.rating_setting_id' => 'nullable|exists:rating_settings,id',
            'evaluations.*.rating' => 'required|integer|min:1|max:5',
            'comments' => 'array|nullable',
            'comments.*.subject_id' => 'required|exists:subjects,id',
            'comments.*.enrolled_subject_id' => 'required|exists:enrolled_subjects,id',
            'comments.*.comment' => 'nullable|string|max:500',
            ],
        [
            'evaluations.*.rating.required' => 'The evaluation rating is required.',
        ]);

        $_enrollment = new Enrollment;

        $enrollment = $_enrollment->getEnrollment($validated['enrollment_id']);
        $student_id = $enrollment->student_id ?? null;
        $semester_id = $enrollment->semester_id ?? null;

        // Save evaluation ratings
        foreach ($validated['evaluations'] as $evaluation) {
            Evaluation::updateOrCreate(
                [
                    'semester_id' => $semester_id,
                    'course_outcome_id' => $evaluation['course_outcome_id'],
                    'student_id' => $student_id,
                ],
                [
                    'subject_id' => $evaluation['subject_id'],
                    'enrolled_subject_id' => $evaluation['enrolled_subject_id'],
                    'rating_setting_id' => $evaluation['rating_setting_id'],
                    'rating' => $evaluation['rating'],
                ]
            );
        }

        // Save subject-level comment
        if (!empty($validated['comments'])) {
            foreach ($validated['comments'] as $commentData) {
                if (!empty($commentData['comment'])) {
                    EvaluationComment::updateOrCreate(
                        [
                            'semester_id' => $semester_id,
                            'subject_id' => $commentData['subject_id'],
                            'student_id' => $student_id,
                        ],
                        [
                            'enrolled_subject_id' => $commentData['enrolled_subject_id'],
                            'comment' => $commentData['comment'],
                        ]
                    );
                }
            }
        }

        return redirect()->back()->with('success', 'Evaluation successfully submitted!');
        
        // return redirect()
        //     ->route('dashboard')
        //     ->with('success', 'Evaluation submitted successfully.');
    }

    public function show($enrollment_id)
    {
        $_enrollment = new Enrollment;

        $enrollment = $_enrollment->getEnrollment($enrollment_id);

        $enrolled_subjects = EnrolledSubject::select('enrolled_subjects.*', 'subjects.subject_code', 'subjects.subject_title', 'course_majors.course_major')
            ->with(['evaluations' => function ($evaluations) {
                $evaluations->select('evaluations.course_outcome_id as id', 'evaluations.enrolled_subject_id', 'evaluations.rating', 'course_outcomes.order_no', 'course_outcomes.course_outcome')
                    ->with(['outcome_links' => function ($outcome_links) {
                        $outcome_links->select('course_outcome_id', 'program_outcomes.po_code')
                            ->join('program_outcomes', 'program_outcomes.id', 'outcome_links.program_outcome_id');
                    }])
                    ->join('course_outcomes', 'course_outcomes.id', 'evaluations.course_outcome_id')
                    ->orderBy('course_outcomes.order_no', 'ASC');
            }, 'evaluation_comment' => function ($evaluation_comment) {
                $evaluation_comment->select('evaluation_comments.id', 'evaluation_comments.enrolled_subject_id', 'evaluation_comments.comment');
            }])
            ->join('faculty_subjects', 'faculty_subjects.id', 'enrolled_subjects.faculty_subject_id')
            ->join('subjects', 'subjects.id', 'faculty_subjects.subject_id')
            ->leftJoin('course_majors', 'course_majors.id', 'subjects.course_major_id')
            ->where('enrolled_subjects.enrollment_id', $enrollment_id)
            ->get();

        return Inertia::render('Student/EvaluationResponse', [
            'enrollment_id' => $enrollment_id,
            'enrollment' => $enrollment,
            'enrolled_subjects' => $enrolled_subjects,
        ]);
    }
}
