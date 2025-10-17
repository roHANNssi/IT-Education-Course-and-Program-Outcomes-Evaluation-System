<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Http\Requests\SettingRequest;
use App\Models\Course;
use App\Models\Curriculum;
use App\Models\ProgramOutcome;
use App\Models\Semester;
use App\Models\Setting;
use Inertia\Inertia;

class SettingController extends Controller
{
    public function index(Request $request)
    {
        $_programoutcome = new ProgramOutcome;
        $_setting = new Setting;
        
        $semester = Semester::where('status', 'active')->first();
        $current_sem_id = $semester->id ?? null;
        $semester_id = $request->semester_id ?? $current_sem_id;

        $qry_sems = Semester::orderBy('semesters.order_num', 'DESC');
        $semesters = $qry_sems->get();

        $setting_types = $_setting->settingType();

        $qry_courses = Course::where('college_id', 10);
        $courses = $qry_courses->orderBy('course_name', 'ASC')->get();

        $curriculums = Curriculum::orderBy('curr_name', 'ASC')->get();
        $po_versions = $_programoutcome->getVersions();

        $settings = Setting::select('settings.*', 'curricula.curr_name', 'courses.course_name', 'courses.course_code')
        ->leftJoin('curricula', 'curricula.id', 'settings.curriculum_id')
        ->leftJoin('courses', 'courses.id', 'settings.course_id')
        ->where('semester_id', $semester_id)
        ->get();
        
        return Inertia::render('Setting/GeneralSetting', [
            'semester_id' => $semester_id,
            'semesters' => $semesters,
            'semesters' => $semesters,
            'setting_types' => $setting_types,
            'settings' => $settings,
            'courses' => $courses,
            'curriculums' => $curriculums,
            'po_versions' => $po_versions,
        ]);
    }

    public function store(SettingRequest $request)
    {
        $validated = $request->validated();

        // Create new record
        $setting = Setting::create([
            'semester_id' => $validated['semester_id'],
            'type' => $validated['type'],
            'course_id' => $validated['course_id'],
            'curriculum_id' => $request->curriculum_id,
            'version' => $request->version,
            'created_by' => auth()->id(),
        ]);

        return redirect()->back()->with('success', 'Setting created successfully!');
    }

    public function update(SettingRequest $request, $id)
    {
        $setting = Setting::findOrFail($id);
        $validated = $request->validated();

        $setting->update([
            'type' => $validated['type'],
            'course_id' => $validated['course_id'],
            'curriculum_id' => $request->curriculum_id,
            'version' => $request->version,
            'updated_by' => auth()->id(),
        ]);

        return redirect()->back()->with('success', 'Setting updated successfully!');
    }
}
