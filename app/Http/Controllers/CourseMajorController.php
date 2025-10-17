<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;
use App\Models\Course;
use App\Models\CourseMajor;

class CourseMajorController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index($get_course_id = null)
    {
        $college_id = Auth::user()->facultyUser->college_id ?? null;
        $designation = Auth::user()->facultyUser->designation ?? null;

        $course_id = null;
        if ($get_course_id != null) {
            $course_id = $get_course_id;
        } else {
            $course_id = Auth::user()->facultyUser->course_id ?? null;
        }
        
        $course = Course::find($course_id);
        $qry_courses = Course::select('courses.*');
        if ($designation!=null && $designation=='program-head') {
            $qry_courses->where('courses.id', $course_id);
        }
        $courses = $qry_courses->orderBy('course_name', 'ASC')->get();

        $course_majors = CourseMajor::where('course_id', $course_id)->orderBy('course_major', 'ASC')->get();

        $course_name = (!empty($course)) ? $course->course_name. ' ('.$course->course_code.')' : '';

        return Inertia::render('Management/CourseMajor', [
            'course_id' => $course_id,
            'course_majors' => $course_majors,
            'courses' => $courses,
            'course_name' => $course_name,
        ]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'course_major' => 'required',
            'year_level' => 'required',
        ]);

        $exists = CourseMajor::where('course_id', $request->course_id)
                    ->where('course_major', $request->course_major)
                    ->where('year_level', $request->year_level)
                    ->exists();

        if ($exists) {
            return back()->withErrors([
                'course_major' => 'Major already exist!',
            ]);
        }

        CourseMajor::create([
            'course_id' => $request->course_id,
            'course_major' => $request->course_major,
            'year_level' => $request->year_level,
            'status' => 'active',
        ]);

        return redirect()->back()->with('success', 'Major successfully saved!');
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $validated = $request->validate([
            'course_major' => 'required',
            'year_level' => 'required',
        ]);

        CourseMajor::find($id)->update([
            'course_major' => $request->course_major,
            'year_level' => $request->year_level,
            'status' => $request->status,
        ]);

        return redirect()->back()->with('success', 'Major successfully updated!');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
