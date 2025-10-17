<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\Course;
use App\Models\Curriculum;
use App\Models\Faculty;
use App\Models\RatingSetting;
use App\Models\Scale;
use App\Models\Semester;
use App\Models\Subject;
use Inertia\Inertia;

class RatingSettingController extends Controller
{
    public function index(Request $request) 
    {
        $user_id = Auth::user()->id ?? null;
        $designation = Auth::user()->facultyUser->designation ?? null;
        $course_id = Auth::user()->facultyUser->course_id ?? null;

        $faculties = Faculty::select('faculties.course_id')->where('faculties.user_id', $user_id)->where('faculties.designation', $designation)->groupBy('faculties.course_id')->get();
        $program_ids = [];
        if ($designation=='program-head' && !empty($faculties)) {
            foreach ($faculties as $faculty) {
                $program_ids[] = $faculty->course_id;
            }
        }

        $qry_courses = Course::select('courses.*', 'curricula.id as curriculum_id', 'curricula.curr_name', 'curricula.curr_detail')->join('curricula', 'curricula.course_id', 'courses.id');
        if (!empty($program_ids)) {
            $qry_courses->whereIn('course_id', $program_ids);
        }
        $programs = $qry_courses->get();

        return Inertia::render('Setting/RatingSetting/Index', [
            'programs' => $programs,
        ]);
    }

    public function show(Request $request, $curriculum_id)
    {
        $_curriculum = new Curriculum;
        $_subject = new Subject;

        $user_id = Auth::user()->id ?? null;
        $designation = Auth::user()->facultyUser->designation ?? null;

        $semester = Semester::where('status', 'active')->first();
        $current_sem_id = $semester->id ?? null;
        $semester_id = $request->semester_id ?? $current_sem_id;
        $yr_level = $request->yr_level ?? 'first';

        $faculties = Faculty::select('faculties.semester_id')->where('faculties.user_id', $user_id)->where('faculties.designation', $designation)->groupBy('faculties.semester_id')->get();
        $semester_ids = [];
        if (!empty($faculties)) {
            foreach ($faculties as $faculty) {
                $semester_ids[] = $faculty->semester_id;
            }
        }

        $qry_sems = Semester::orderBy('semesters.order_num', 'DESC');
        if (!empty($semester_ids)) {
            $qry_sems->whereIn('semesters.id', $semester_ids);
        }
        $semesters = $qry_sems->get();

        $curriculum = $_curriculum->getCurriculum($curriculum_id);
        $course_id = $curriculum->course_id ?? null;

        $subjects = Subject::select('subjects.*', 'course_majors.course_major')
            ->with(['rating_setting' => function ($rating_setting) use ($semester_id) {
                $rating_setting->select('id', 'subject_id', 'semester_id', 'scale_version', 'co_version', 'status')->where('rating_settings.semester_id', $semester_id);
            }, 'course_outcomes' => function ($course_outcomes) {
                $course_outcomes->select('course_outcomes.subject_id', 'course_outcomes.version')->groupBy('course_outcomes.subject_id', 'course_outcomes.version');
            }])
            ->leftJoin('course_majors', 'course_majors.id', 'subjects.course_major_id')
            ->where('subjects.curriculum_id', $curriculum_id)
            ->where('subjects.yr_level', $yr_level)
            ->orderBy('subjects.subject_title', 'ASC')
            ->get();

        $scales = Scale::select('version')->groupBy('version')->get();

        return Inertia::render('Setting/RatingSetting/Show', [
            'curriculum_id' => $curriculum_id,
            'semester_id' => $semester_id,
            'yr_level' => $yr_level,
            'semesters' => $semesters,
            'curriculum' => $curriculum,
            'subjects' => $subjects,
            'scales' => $scales,
        ]);
    }

    public function save(Request $request)
    {
        $validated = $request->validate([
            'scale_version' => 'required',
            'co_version' => 'required',
        ], [
            'co_version.required' => 'The course outcome version field is required.'
        ]);
        
        $rs_exist = RatingSetting::where('semester_id', $request->semester_id)->where('subject_id', $request->subject_id)->first();

        if (!empty($rs_exist)) {
            RatingSetting::find($rs_exist->id)->update([
                'scale_version' => $request->scale_version,
                'co_version' => $request->co_version,
            ]);
        } else {
            RatingSetting::create([
                'semester_id' => $request->semester_id,
                'subject_id' => $request->subject_id,
                'scale_version' => $request->scale_version,
                'co_version' => $request->co_version,
            ]);
        }
        return redirect()->back()->with('success', 'Subject successfully saved!');
    }
}
