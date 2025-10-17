<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;
use App\Models\Course;
use App\Models\CourseMajor;
use App\Models\Curriculum;
use App\Models\Subject;

class CurriculumCourseController extends Controller
{
    // This controller is dedicated for subjects (tagged as courses based on curriculum)
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $_curriculum = new Curriculum;
        $_subject = new Subject;

        $curriculum_id = $request->curriculum_id ?? null;
        $designation = Auth::user()->facultyUser->designation ?? null;
        $auth_course_id = Auth::user()->facultyUser->course_id ?? null;
        $curriculum = $_curriculum->getCurriculum($curriculum_id);

        $course_id = null;
        if ($request->course_id!=null) {
            $course_id = $request->course_id;
        } else {
            if (!empty($curriculum)) {
                $course_id = $curriculum->course_id;
            } else {
                $course_id = $auth_course_id;
            }
        }
        $yr_level = $request->yr_level ?? 'first';

        $course_majors = CourseMajor::where('course_id', $course_id)->orderBy('course_major', 'ASC')->get();

        $subjects = Subject::select('subjects.*', 'course_majors.course_major')
            ->with(['course_outcomes' => function ($course_outcomes) {
                $course_outcomes->select('course_outcomes.subject_id', 'course_outcomes.version')->groupBy('course_outcomes.subject_id', 'course_outcomes.version');
            }])
            ->leftJoin('course_majors', 'course_majors.id', 'subjects.course_major_id')
            ->where('subjects.curriculum_id', $curriculum_id)
            ->where('subjects.yr_level', $yr_level)
            ->orderBy('subjects.subject_title', 'ASC')
            ->get();

        $coursemajors = [];
        if (!empty($course_majors)) {
            foreach ($course_majors as $course_major) {
                array_push($coursemajors, ['value'=>$course_major->id, 'label'=>$course_major->course_major]);
            }
        }
        
        return Inertia::render('Management/CurriculumCourse', [
            'curriculum_id' => $curriculum_id,
            'yr_level' => $yr_level,
            'curriculum' => $curriculum,
            'subjects' => $subjects,
            'coursemajors' => $coursemajors,
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $_curriculum = new Curriculum;

        $validated = $request->validate([
            'subject_type' => 'required',
            'subject_code' => 'required',
            'subject_title' => 'required',
            'yr_level' => 'required',
        ], [
            'subject_type.required' => 'The  type field is required.'
        ]);
        $curriculum_id = $request->curriculum_id;
        $curriculum = $_curriculum->getCurriculum($curriculum_id);
        $course_id = (!empty($curriculum)) ? $curriculum->course_id : null;

        $qry_exists = Subject::where('course_id', $course_id)
            ->where('curriculum_id', $curriculum_id);
        if ($request->course_major_id!="") {
            $qry_exists->where('subjects.course_major_id', $request->course_major_id);
        }
            
        $exists = $qry_exists->where('subject_type', $request->subject_type)
                ->where('subject_code', $request->subject_code)
                ->where('subject_title', $request->subject_title)
                ->where('yr_level', $request->yr_level)
                ->exists();

        if ($exists) {
            return back()->withErrors([
                'subject_code' => 'Course already exist!',
            ]);
        }

        Subject::create([
            'course_id' => $course_id,
            'curriculum_id' => $curriculum_id,
            'course_major_id' => $request->course_major_id,
            'subject_type' => $request->subject_type,
            'subject_code' => $request->subject_code,
            'subject_title' => $request->subject_title,
            'yr_level' => $request->yr_level,
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
            'subject_type' => 'required',
            'subject_code' => 'required',
            'subject_title' => 'required',
            'yr_level' => 'required',
        ], [
            'subject_type.required' => 'The  type field is required.'
        ]);

        Subject::find($id)->update([
            'course_major_id' => $request->course_major_id,
            'subject_type' => $request->subject_type,
            'subject_code' => $request->subject_code,
            'subject_title' => $request->subject_title,
            'yr_level' => $request->yr_level,
            'status' => $request->status,
        ]);

        return redirect()->back()->with('success', 'Course successfully saved!');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
