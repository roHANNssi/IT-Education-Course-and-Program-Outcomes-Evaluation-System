<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;
use App\Models\Course;
use App\Models\EvaluationSchedule;
use App\Models\Semester;

class EvaluationScheduleController extends Controller
{
    public function index(Request $request)
    {
        $semester = Semester::where('status', 'active')->first();
        $current_sem_id = $semester->id ?? null;
        $semester_id = $request->semester_id ?? $current_sem_id;

        $qry_sems = Semester::orderBy('semesters.order_num', 'DESC');
        $semesters = $qry_sems->get();

        $sem = Semester::where('id', $semester_id)->first();

        $qry_courses = Course::where('college_id', 10);
        $courses = $qry_courses->orderBy('course_name', 'ASC')->get();

        $evaluation_schedules = EvaluationSchedule::select('evaluation_schedules.*', 'courses.course_name', 'courses.course_code')
            ->leftJoin('courses', 'courses.id', 'evaluation_schedules.course_id')
            ->where('semester_id', $semester_id)
            ->get();

        return Inertia::render('Setting/EvaluationSchedule', [
            'semester_id' => $semester_id,
            'sem' => $sem,
            'semesters' => $semesters,
            'courses' => $courses,
            'evaluation_schedules' => $evaluation_schedules,
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'course_id' => 'required|integer|exists:courses,id',
            'start_date' => 'required',
            'end_date' => 'required',
        ]);

        $exists = EvaluationSchedule::where('semester_id', $request->semester_id)
                    ->where('course_id', $request->course_id)
                    ->exists();

        if ($exists) {
            return back()->withErrors([
                'duplicate' => 'Schedule for selected program already exist!',
            ]);
        }

        EvaluationSchedule::create([
            'semester_id' => $request->semester_id,
            'course_id' => $request->course_id,
            'start_date' => $request->start_date,
            'end_date' => $request->end_date,
        ]);

        return redirect()->back()->with('success', 'Schedule successfully saved!');
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'course_id' => 'required|integer|exists:courses,id',
            'start_date' => 'required',
            'end_date' => 'required',
        ]);

        EvaluationSchedule::find($id)->update([
            'course_id' => $request->course_id,
            'start_date' => $request->start_date,
            'end_date' => $request->end_date,
        ]);

        return redirect()->back()->with('success', 'Schedule successfully updated!');
    }
}
