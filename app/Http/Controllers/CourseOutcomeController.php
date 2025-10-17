<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;
use App\Models\CourseOutcome;
use App\Models\ProgramOutcome;
use App\Models\Subject;
use App\Models\OutcomeLink;

class CourseOutcomeController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $_courseoutcome = new CourseOutcome;
        $subject_id = $request->subject_id ?? null;
        $version = $request->version ?? null;

        $designation = Auth::user()->facultyUser->designation ?? null;

        $lastest_version = $_courseoutcome->getVersion($subject_id, 'latest');
        $versions = CourseOutcome::select('course_outcomes.version')->where('subject_id', $subject_id)->groupBy('version')->orderBy('version', 'ASC')->get();
        $version = ($version!=null) ? $version : $lastest_version;
        $new_version = $lastest_version + 1;

        $subject = Subject::select('subjects.*', 'courses.course_name', 'courses.course_code')
            ->join('courses', 'courses.id', 'subjects.course_id')
            ->leftJoin('course_majors', 'course_majors.id', 'subjects.course_major_id')
            ->where('subjects.id', $subject_id)
            ->first();
        $course_id = (!empty($subject)) ? $subject->course_id : null;
        $curriculum_id = (!empty($subject)) ? $subject->curriculum_id : null;
        $course_name = (!empty($subject)) ? $subject->course_name. ' ('.$subject->course_code.')' : '';
        $subject_name = (!empty($subject)) ? $subject->subject_title. ' ('.$subject->subject_code.')' : '';

        $new_order_no_cv = $_courseoutcome->getNextOrderNo($subject_id, $version);

        $course_outcomes = CourseOutcome::select('course_outcomes.*')
            ->with(['outcome_links' => function ($outcome_links) {
                $outcome_links->select('outcome_links.id', 'outcome_links.course_outcome_id', 'outcome_links.program_outcome_id', 'program_outcomes.po_code', 'program_outcomes.po_description')
                    ->join('program_outcomes', 'program_outcomes.id', 'outcome_links.program_outcome_id');
            }, 'evaluations' => function ($evaluations) {
                $evaluations->select('course_outcome_id');
            }])
            ->where('course_outcomes.subject_id', $subject_id)
            ->where('course_outcomes.version', $version)
            ->orderBy('course_outcomes.order_no', 'ASC')
            ->get();

        $program_outcomes = ProgramOutcome::select('program_outcomes.*')->where('course_id', $course_id)->where('status', 'active')->orderBy('program_outcomes.order_number', 'ASC')->get();

        $back_route = ($designation=='faculty') ? 'assignedsubjects.assignedSubjects' : 'curriculums.courses.index';

        return Inertia::render('Management/CourseOutcome', [
            'subject_id' => $subject_id,
            'curriculum_id' => $curriculum_id,
            'subject_name' => $subject_name,
            'course_name' => $course_name,
            'version' => $version,
            'versions' => $versions,
            'new_version' => $new_version,
            'program_outcomes' => $program_outcomes,
            'course_outcomes' => $course_outcomes,
            'designation' => $designation,
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'order_no' => 'required',
            'course_outcome' => 'required|string',
            'program_outcomes' => 'array',
            'program_outcomes.*' => 'integer|exists:program_outcomes,id',
        ]);

        $exists = CourseOutcome::where('subject_id', $request->subject_id)
                    ->where('version', $request->version)
                    ->where('order_no', $request->order_no)
                    ->exists();

        if ($exists) {
            return back()->withErrors([
                'order_no' => 'Course Outcome already exist!',
            ]);
        }

        $course_outcome = CourseOutcome::create([
            'subject_id' => $request->subject_id,
            'version' => $request->version,
            'order_no' => $request->order_no,
            'course_outcome' => $request->course_outcome,
            'status' => 'active',
        ]);

        if ($course_outcome) {
            if (!empty($request->program_outcomes)) {
                foreach ($request->program_outcomes as $program_outcome_id) {
                    OutcomeLink::create([
                        'course_outcome_id' => $course_outcome->id,
                        'program_outcome_id' => $program_outcome_id,
                    ]);
                }
            }
        }

        return redirect()->back()->with('success', 'Course Outcome successfully saved!');
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $validated = $request->validate([
            'order_no' => 'required',
            'course_outcome' => 'required',
        ]);

        $courseOutcome = CourseOutcome::findOrFail($id);

        $courseOutcome->update([
            'order_no' => $request->order_no,
            'course_outcome' => $request->course_outcome,
            'status' => $request->status,
        ]);

        // Sync POs (assuming many-to-many relationship)
        $courseOutcome->outcome_links()->delete(); // remove old
        foreach ($request->program_outcomes as $poId) {
            $courseOutcome->outcome_links()->create([
                'program_outcome_id' => $poId,
            ]);
        }

        return redirect()->back()->with('success', 'Course Outcome successfully saved!');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        CourseOutcome::find($id)->delete();
        return redirect()->back()->with('success', 'Program Outcome successfully deleted!');
    }
}
