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

class UserController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $user = Auth::user();
        $faculty = $user->faculty;

        $role = $request->role ?? 'faculty';
        $college_id = 10;

        $users = User::select('users.*')
            ->with(['faculty' => function ($faculty){
                $faculty->select('id', 'user_id', 'designation')
                    ->where('faculties.status', 'active');
            }, 'faculties' => function ($faculties){
                $faculties->select('id', 'user_id', 'designation')
                    ->where('faculties.designation', '<>', 'faculty');
            }])
            ->where('users.role', $role)
            ->orderBy('users.last_name', 'ASC')
            ->get();
        $semester = Semester::where('semesters.status', 'active')->first();
        $sem_id = (!empty($semester)) ? $semester->id : null;
        $current_sem = (!empty($semester)) ? $semester->sem.' Semester, A.Y. '.$semester->acad_year : '';
        $courses = Course::select('courses.*')->where('courses.college_id', $college_id)->where('courses.status', 'active')->get();

        return Inertia::render('Management/User', [
            'role' => $role,
            'users' => $users,
            'sem_id' => $sem_id,
            'current_sem' => $current_sem,
            'courses' => $courses,
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'email' => 'required|string|lowercase|email|max:255|unique:'.User::class,
            'last_name' => 'required|string|max:150',
            'first_name' => 'required|string|max:150',
            'mid_name' => 'required|string|max:150',
            'gender' => 'required|string',
        ]);

        $password = Str::password(8, true, true, false);

        $user = User::create([
            'name' => $request->last_name.', '.$request->first_name.' '.$request->mid_name,
            'email' => $request->email,
            'role' => $request->role,
            'last_name' => $request->last_name,
            'first_name' => $request->first_name,
            'mid_name' => $request->mid_name,
            'name_ext' => $request->name_ext,
            'gender' => $request->gender,
            'password' => Hash::make($password),
        ]);

        if ($request->semester_id) {
            $exists = Faculty::where('user_id', $user->id)
                    ->where('college_id', 10)
                    ->where('semester_id', $user->semester_id)
                    ->where('designation', $user->designation)
                    ->where('course_id', $user->course_id)
                    ->exists();
                    
            if (!$exists) {
                Faculty::create([
                    'user_id' => $user->id,
                    'college_id' => 10,
                    'semester_id' => $request->semester_id,
                    'designation' => $request->designation ?? 'faculty',
                    'course_id' => $request->course_id ?? null,
                ]);
            }
        }

        $user->role = 'faculty';
        $user->plain_password = $password;

        event(new Registered($user));

        return redirect()->back()->with('success', 'User successfully saved!');
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $request->validate([
            'email' => 'required|string|lowercase|email|max:255',
            'last_name' => 'required|string|max:150',
            'first_name' => 'required|string|max:150',
            'mid_name' => 'required|string|max:150',
            'gender' => 'required|string',
        ]);

        $user = User::find($id);

        if ($user->email != $request->email) {
            $password = Str::password(8, true, true, false);
            
            User::find($id)->update([
                'name' => $request->last_name.', '.$request->first_name.' '.$request->mid_name,
                'email' => $request->email,
                'last_name' => $request->last_name,
                'first_name' => $request->first_name,
                'mid_name' => $request->mid_name,
                'name_ext' => $request->name_ext,
                'gender' => $request->gender,
                'password' => Hash::make($password),
            ]);

            $user->role = 'faculty';
            $user->plain_password = $password;

            event(new Registered($user));
        } else {
            User::find($id)->update([
                'name' => $request->last_name.', '.$request->first_name.' '.$request->mid_name,
                'last_name' => $request->last_name,
                'first_name' => $request->first_name,
                'mid_name' => $request->mid_name,
                'name_ext' => $request->name_ext,
                'gender' => $request->gender,
            ]);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
