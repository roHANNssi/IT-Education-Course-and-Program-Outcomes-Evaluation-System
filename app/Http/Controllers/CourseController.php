<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;
use App\Models\Course;

class CourseController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index($college_id = null)
    {
        $courses = Course::orderBy('course_name', 'ASC')->get();

        return Inertia::render('Management/Course', [
            'college_id' => $college_id,
            'courses' => $courses,
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'course_name' => 'required',
            'course_code' => 'required',
        ]);

        $exists = Course::where('course_name', $request->course_name)
                    ->where('course_code', $request->course_code)
                    ->exists();

        if ($exists) {
            return back()->withErrors([
                'course_name' => 'Course already exist!',
            ]);
        }

        Course::create([
            'college_id' => 10,
            'course_name' => $request->course_name,
            'course_code' => $request->course_code,
            'status' => 'active',
        ]);

        return redirect()->back()->with('success', 'Course successfully saved!');
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $validated = $request->validate([
            'course_name' => 'required',
            'course_code' => 'required',
        ]);

        Course::find($id)->update([
            'course_name' => $request->course_name,
            'course_code' => $request->course_code,
        ]);

        return redirect()->back()->with('success', 'Course successfully updated!');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
