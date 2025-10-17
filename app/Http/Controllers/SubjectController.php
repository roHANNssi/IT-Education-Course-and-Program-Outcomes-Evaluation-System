<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;
use App\Models\Course;
use App\Models\CourseMajor;
use App\Models\Subject;

class SubjectController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $designation = Auth::user()->facultyUser->designation ?? null;

        $course_id = null;
        if ($request->course_id!=null) {
            $course_id = $request->course_id;
        } else {
            $course_id = Auth::user()->facultyUser->course_id ?? null;
        }
        $yr_level = $request->yr_level ?? 'first';

        $course = Course::find($course_id);
        $qry_courses = Course::select('courses.*');
        if ($designation!=null && $designation=='program-head') {
            $qry_courses->where('courses.id', $course_id);
        }
        $courses = $qry_courses->orderBy('course_name', 'ASC')->get();
        
        $course_majors = CourseMajor::where('course_id', $course_id)->orderBy('course_major', 'ASC')->get();

        $subjects = Subject::select('subjects.*', 'course_majors.course_major')
            ->leftJoin('course_majors', 'course_majors.id', 'subjects.course_major_id')
            ->where('subjects.course_id', $course_id)
            ->where('subjects.yr_level', $yr_level)
            ->orderBy('subjects.subject_title', 'ASC')
            ->get();

        $coursemajors = [];
        if (!empty($course_majors)) {
            foreach ($course_majors as $course_major) {
                array_push($coursemajors, ['value'=>$course_major->id, 'label'=>$course_major->course_major]);
            }
        }

        $course_name = (!empty($course)) ? $course->course_name. ' ('.$course->course_code.')' : '';

        return Inertia::render('Management/Subject', [
            'course_id' => $course_id,
            'yr_level' => $yr_level,
            'subjects' => $subjects,
            'courses' => $courses,
            'coursemajors' => $coursemajors,
            'course_name' => $course_name,
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'subject_code' => 'required',
            'subject_title' => 'required',
            'yr_level' => 'required',
        ]);

        $qry_exists = Subject::where('course_id', $request->course_id);
            if ($request->course_major_id!="") {
                $qry_exists->where('subjects.course_major_id', $request->course_major_id);
            }
            
        $exists = $qry_exists->where('subject_code', $request->subject_code)
                ->where('subject_title', $request->subject_title)
                ->where('yr_level', $request->yr_level)
                ->exists();

        if ($exists) {
            return back()->withErrors([
                'subject_code' => 'Subject already exist!',
            ]);
        }

        Subject::create([
            'course_id' => $request->course_id,
            'course_major_id' => $request->course_major_id,
            'subject_code' => $request->subject_code,
            'subject_title' => $request->subject_title,
            'yr_level' => $request->yr_level,
            'status' => 'active',
        ]);

        return redirect()->back()->with('success', 'Subject successfully saved!');
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $validated = $request->validate([
            'subject_code' => 'required',
            'subject_title' => 'required',
            'yr_level' => 'required',
        ]);

        Subject::find($id)->update([
            'course_major_id' => $request->course_major_id,
            'subject_code' => $request->subject_code,
            'subject_title' => $request->subject_title,
            'yr_level' => $request->yr_level,
            'status' => $request->status,
        ]);

        return redirect()->back()->with('success', 'Subject successfully saved!');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
