<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Auth\Events\Registered;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules;
use Inertia\Inertia;
use App\Models\Course;
use App\Models\Faculty;
use App\Models\Semester;
use App\Models\User;

class FacultyController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index($get_sem_id = null)
    {
        $user_id = Auth::user()->id;
        // $semester_id = Auth::user()->facultyUser->semester_id ?? null;
        $college_id = Auth::user()->facultyUser->college_id ?? null;
        $designation = Auth::user()->facultyUser->designation ?? null;
        $course_id = Auth::user()->facultyUser->course_id ?? null;

        $semester = Semester::where('semesters.status', 'active')->first();
        $sem_id = (!empty($semester)) ? $semester->id : null;

        $semester_id = $sem_id;
        if ($get_sem_id!=null) {
            $semester_id = $get_sem_id;
        } else {
            $semester_id = Auth::user()->facultyUser->semester_id;
        }
        
        $qry_faculties = Faculty::select('faculties.*', 'users.email', 'users.last_name', 'users.first_name', 'users.mid_name', 'users.name_ext', 'users.gender')
            ->join('users', 'users.id', 'faculties.user_id')
            ->where('faculties.semester_id', $semester_id)
            ->where('faculties.college_id', $college_id);
        if ($designation == 'dean') {
            $qry_faculties->where('faculties.designation', '<>', 'dean');
        } elseif ($designation == 'program-head') {
            $qry_faculties->whereIn('faculties.designation', ['faculty', 'program-head', 'dean'])
                ->where('course_id', $course_id);
        }
        $faculties = $qry_faculties->orderBy('users.last_name','ASC')
            ->get();

        $semesters = Semester::orderBy('order_num', 'DESC')->get();
        $course = Course::find($course_id);
        $course_name = (!empty($course)) ? $course->course_name. ' ('.$course->course_code.')' : '';

        $user_ids = [];
        if (!empty($faculties)) {
            foreach ($faculties as $faculty) {
                $user_ids[] = $faculty->user_id;
            }
        }
        
        $users = User::where('users.role', 'faculty')->whereNotIn('users.id', $user_ids)->get();

        return Inertia::render('Management/FacultyMember', [
            'semester_id' => $semester_id,
            'course_id' => $course_id,
            'faculties' => $faculties,
            'semesters' => $semesters,
            'course' => $course,
            'users' => $users,
        ]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'designation' => 'required|string',
            'course_id'   => 'required|integer',
            'semester_id' => 'required|integer',
            'user_ids'    => 'required|array',
            'user_ids.*'  => 'integer|exists:users,id', // each must be a valid user id
        ]);

        // Loop through array of IDs
        foreach ($data['user_ids'] as $userId) {
            Faculty::create([
                'user_id'     => $userId,
                'college_id'  => 10,
                'semester_id' => $data['semester_id'],
                'designation' => $data['designation'],
                'course_id'   => $data['course_id'],
                'status'   => 'active',
            ]);
        }

        return redirect()->back()->with('success', 'Faculty member(s) successfully saved!');
    }

    public function designationLogs($user_id)
    {
        $user = User::find($user_id);
        $faculty_name = (!empty($user)) ? $user->name : null;
        $faculties = Faculty::select('faculties.*', 'semesters.sem', 'semesters.acad_year', 'courses.course_name', 'courses.course_code')
            ->join('semesters', 'semesters.id', 'faculties.semester_id')
            ->leftJoin('courses', 'courses.id', 'faculties.course_id')
            ->where('faculties.user_id', $user_id)
            ->get();
        $semesters = Semester::orderBy('semesters.order_num', 'DESC')->get();

        $college_id = 10;
        $courses = Course::select('courses.*')->where('courses.college_id', $college_id)->where('courses.status', 'active')->get();

        return Inertia::render('Management/FacultyDesignation', [
            'user_id' => $user_id,
            'user' => $user,
            'faculty_name' => $faculty_name,
            'faculties' => $faculties,
            'semesters' => $semesters,
            'courses' => $courses,
        ]);
    }

    public function storeDesignation(Request $request)
    {
        $request->validate([
            'semester_id' => 'required',
            'designation' => 'required|string|max:150',
        ]);

        $qry_exists = Faculty::where('semester_id', $request->semester_id)
                    ->where('designation', $request->designation);
        if ($request->course_id) {
            $qry_exists->where('course_id', $request->course_id);
        }
        $exists = $qry_exists->exists();

        if ($exists) {
            return back()->withErrors([
                'semester_id' => 'Designation data already exist!',
            ]);
        }

        Faculty::create([
            'user_id' => $request->user_id,
            'college_id' => 10,
            'semester_id' => $request->semester_id,
            'designation' => $request->designation ?? 'faculty',
            'course_id' => $request->course_id ?? null,
        ]);

        return redirect()->back()->with('success', 'Designation successfully saved!');
    }

    public function updateDesignation(Request $request, $id)
    {
        $request->validate([
            'semester_id' => 'required',
            'designation' => 'required|string|max:150',
        ]);

        Faculty::find($id)->update([
            'semester_id' => $request->semester_id,
            'designation' => $request->designation ?? 'faculty',
            'course_id' => $request->course_id ?? null,
        ]);

        return redirect()->back()->with('success', 'Designation successfully updated!');
    }
}
