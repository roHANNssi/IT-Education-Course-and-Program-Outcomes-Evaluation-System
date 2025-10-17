<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;
use App\Models\Course;
use App\Models\CourseMajor;
use App\Models\Faculty;
use App\Models\FacultySubject;
use App\Models\Semester;
use App\Models\Subject;
use App\Models\User;

class FacultySubjectController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index($faculty_id, $semester_id, $mother_program=null, $yr_level='first')
    {
        $semester = Semester::find($semester_id);
        $faculty = Faculty::select('faculties.*', 'users.last_name', 'users.first_name', 'users.mid_name', 'users.name_ext')
            ->join('users', 'users.id', 'faculties.user_id')
            ->where('faculties.id', $faculty_id)
            ->first();

        $course_id = null;
        $mother_program_id = (!empty($faculty)) ? $faculty->course_id : null;
        if ($mother_program!=null) {
            $course_id = $mother_program;
        } else {
            $course_id = (!empty($faculty)) ? $faculty->course_id : null;
        }
        
        $courses = Course::orderBy('course_name', 'ASC')->get();

        $subjects = Subject::select('subjects.*', 'course_majors.course_major')
            ->leftJoin('course_majors', 'course_majors.id', 'subjects.course_major_id')
            ->where('subjects.course_id', $course_id)
            ->where('subjects.yr_level', $yr_level)
            ->orderBy('subjects.subject_title', 'ASC')
            ->get();

        $faculty_subjects = FacultySubject::select('faculty_subjects.*', 'subjects.subject_code', 'subjects.subject_title', 'subjects.yr_level', 'courses.course_name', 'courses.course_code', 'course_majors.course_major')
            ->join('subjects', 'subjects.id', 'faculty_subjects.subject_id')
            ->join('courses', 'courses.id', 'subjects.course_id')
            ->leftJoin('course_majors', 'course_majors.id', 'subjects.course_major_id')
            ->where('faculty_subjects.faculty_id', $faculty_id)
            ->where('faculty_subjects.semester_id', $semester_id)
            ->where('subjects.course_id', $course_id)
            ->where('subjects.yr_level', $yr_level)
            ->get();

        $sem = (!empty($semester)) ? $semester->sem.' Semester, A.Y. '.$semester->acad_year : '';

        $name_ext = (!empty($faculty) && $faculty->name_ext!=null) ? ' '.$faculty->name_ext : ''; 
        $faculty_name = (!empty($faculty)) ? $faculty->last_name.', '.$faculty->first_name.' '.$faculty->mid_name.$name_ext : '';

        return Inertia::render('Management/FacultySubject', [
            'faculty_id' => $faculty_id,
            'semester_id' => $semester_id,
            'yr_level' => $yr_level,
            'course_id' => $course_id,
            'mother_program_id' => $mother_program_id,
            'subjects' => $subjects,
            'faculty_name' => $faculty_name,
            'sem' => $sem,
            'courses' => $courses,
            'faculty_subjects' => $faculty_subjects,
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'subject_id' => 'required',
            'section' => 'required',
        ]);

        $exists = FacultySubject::where('faculty_id', $request->faculty_id)->where('semester_id', $request->semester_id)->where('subject_id', $request->subject_id)->where('section', $request->section)->exists();

        if ($exists) {
            return back()->withErrors([
                'subject_id' => 'Assigned Subject and Section already exist!',
            ]);
        }

        FacultySubject::create([
            'faculty_id' => $request->faculty_id,
            'semester_id' => $request->semester_id,
            'subject_id' => $request->subject_id,
            'section' => strtoupper($request->section),
        ]);

        return redirect()->back()->with('success', 'Assigned Subject successfully saved!');
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $validated = $request->validate([
            'subject_id' => 'required',
            'section' => 'required',
        ]);

        FacultySubject::find($id)->update([
            'subject_id' => $request->subject_id,
            'section' => strtoupper($request->section),
        ]);

        return redirect()->back()->with('success', 'Assigned Subject successfully updated!');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }

    public function assignedSubjects(Request $request)
    {
        $get_sem_id = $request->get_sem_id ?? null;
        $get_course_id = $request->get_course_id ?? null;

        $faculty_id = Auth::user()->facultyUser->id ?? null;
        $college_id = Auth::user()->facultyUser->college_id ?? null;
        $designation = Auth::user()->facultyUser->designation ?? null;
        $faculty = Faculty::find($faculty_id);
        $mother_program_id = (!empty($faculty)) ? $faculty->course_id : null;

        $course_id = null;
        if ($get_course_id!=null) {
            $course_id = $get_course_id;
        } else {
            $course_id = (!empty($faculty)) ? $faculty->course_id : null;
        }

        $semester_id = null;
        if ($get_sem_id!=null) {
            $semester_id = $get_sem_id;
        } else {
            $semester_id = Auth::user()->facultyUser->semester_id;
        }

        $semesters = Semester::orderBy('semesters.order_num', 'DESC')->get();
        $courses = Course::orderBy('course_name', 'ASC')->get();
        
        $faculty_subjects = FacultySubject::select('faculty_subjects.*', 'subjects.subject_code', 'subjects.subject_title', 'subjects.yr_level', 'courses.course_name', 'courses.course_code', 'course_majors.course_major')
            ->join('subjects', 'subjects.id', 'faculty_subjects.subject_id')
            ->join('courses', 'courses.id', 'subjects.course_id')
            ->leftJoin('course_majors', 'course_majors.id', 'subjects.course_major_id')
            ->where('faculty_subjects.faculty_id', $faculty_id)
            ->where('faculty_subjects.semester_id', $semester_id)
            ->where('subjects.course_id', $course_id)
            ->get();

        return Inertia::render('Management/AssignedSubject', [
            'faculty_id' => $faculty_id,
            'college_id' => $college_id,
            'semester_id' => $semester_id,
            'course_id' => $course_id,
            'mother_program_id' => $mother_program_id,
            'semesters' => $semesters,
            'courses' => $courses,
            'faculty_subjects' => $faculty_subjects,
        ]);
    }
}
