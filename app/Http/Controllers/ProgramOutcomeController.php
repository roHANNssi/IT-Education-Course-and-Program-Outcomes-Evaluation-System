<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;
use App\Models\Course;
use App\Models\Faculty;
use App\Models\ProgramOutcome;
use App\Models\Semester;

class ProgramOutcomeController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index($course_id = null, $version = null)
    {
        $_programoutcome = new ProgramOutcome;
        $_semester = new Semester;

        $designation = Auth::user()->facultyUser->designation ?? null;

        $semester = $_semester->getByStatus('active');
        $active_semester = $semester->id ?? null;

        $lastest_version = $_programoutcome->getVersion($course_id, 'latest');
        $versions = ProgramOutcome::select('program_outcomes.version')->where('course_id', $course_id)->groupBy('version')->orderBy('version', 'ASC')->get();
        $version = ($version!=null) ? $version : $lastest_version;
        $new_version = $lastest_version + 1;

        $course = Course::find($course_id);
        $course_name = (!empty($course)) ? $course->course_name. ' ('.$course->course_code.')' : '';

        $program_ids = [];
        if ($designation=='program-head') {
            $faculty = Faculty::where('user_id', Auth::user()->id)->where('semester_id', $active_semester)->first();
            if (!empty($faculty)) {
                $program_ids[] = $faculty->course_id;
            }
        }

        $qry_courses = Course::select('courses.*');
        if ($designation=='program-head') {
            $qry_courses->whereIn('courses.id', $program_ids);
        }
        $courses = $qry_courses->orderBy('course_name', 'ASC')->get();

        $program_outcomes = ProgramOutcome::select('program_outcomes.*')
            ->with(['outcome_links' => function ($outcome_links) {
                $outcome_links->select('program_outcome_id');
            }])
            ->where('program_outcomes.course_id', $course_id)
            ->where('program_outcomes.version', $version)
            ->orderBy('program_outcomes.order_number', 'ASC')
            ->get();

        return Inertia::render('Management/ProgramOutcome', [
            'course_id' => $course_id,
            'course_name' => $course_name,
            'courses' => $courses,
            'version' => $version,
            'versions' => $versions,
            'new_version' => $new_version,
            'program_outcomes' => $program_outcomes,
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'po_code' => 'required',
            'po_description' => 'required',
            'order_number' => 'required|numeric',
        ]);

        $exists = ProgramOutcome::where('course_id', $request->course_id)
                    ->where('version', $request->version)
                    ->where('po_code', $request->po_code)
                    ->exists();

        if ($exists) {
            return back()->withErrors([
                'po_code' => 'Program Outcome already exist!',
            ]);
        }

        ProgramOutcome::create([
            'course_id' => $request->course_id,
            'version' => $request->version,
            'po_code' => $request->po_code,
            'po_description' => $request->po_description,
            'order_number' => $request->order_number,
            'status' => 'active',
        ]);

        return redirect()->back()->with('success', 'Program Outcome successfully saved!');
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $validated = $request->validate([
            'po_code' => 'required',
            'po_description' => 'required',
            'order_number' => 'required|numeric',
        ]);

        ProgramOutcome::find($id)->update([
            'po_code' => $request->po_code,
            'po_description' => $request->po_description,
            'order_number' => $request->order_number,
            'status' => $request->status,
        ]);

        return redirect()->back()->with('success', 'Program Outcome successfully updated!');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        ProgramOutcome::find($id)->delete();
        return redirect()->back()->with('success', 'Program Outcome successfully deleted!');
    }
}
