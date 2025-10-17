<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;
use App\Models\Course;
use App\Models\Curriculum;

class CurriculumController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $designation = Auth::user()->facultyUser->designation ?? null;
        $course_id = Auth::user()->facultyUser->course_id ?? null;

        $qry_courses = Course::where('college_id', 10);
        if ($designation=='program-head') {
            $qry_courses->where('courses.id', $course_id);
        }
        $courses = $qry_courses->orderBy('course_name', 'ASC')->get();

        $qry_curriculium = Curriculum::select('curricula.*', 'courses.course_code', 'courses.course_name')
            ->join('courses','courses.id','curricula.course_id');
        if ($designation=='program-head') {
            $qry_curriculium->where('curricula.course_id', $course_id);
        }
        $curriculums = $qry_curriculium->orderBy('curricula.id', 'ASC')
            ->get();
        
        return Inertia::render('Management/Curriculum', [
            'course_id' => $course_id,
            'courses' => $courses,
            'curriculums' => $curriculums,
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'course_id' => 'required',
            'curr_name' => 'required',
            'curr_detail' => 'required',
        ]);

        $curr_stat = $request->curr_stat ?? 'active';

        Curriculum::create([
            'course_id' => $request->course_id,
            'curr_name' => $request->curr_name,
            'curr_detail' => $request->curr_detail,
            'curr_stat' =>  $curr_stat,
        ]);

        return redirect()->back()->with('success', 'Curriculum successfully saved!');
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $validated = $request->validate([
            'course_id' => 'required',
            'curr_name' => 'required',
            'curr_detail' => 'required',
        ]);

        $curr_stat = $request->curr_stat;

        Curriculum::find($id)->update([
            'course_id' => $request->course_id,
            'curr_name' => $request->curr_name,
            'curr_detail' => $request->curr_detail,
            'curr_stat' =>  $curr_stat,
        ]);

        return redirect()->back()->with('success', 'Curriculum successfully saved!');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
