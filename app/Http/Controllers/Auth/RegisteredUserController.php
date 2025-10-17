<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\Course;
use App\Models\Student;
use App\Models\User;
use Illuminate\Auth\Events\Registered;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules;
use Inertia\Inertia;
use Inertia\Response;

class RegisteredUserController extends Controller
{
    /**
     * Display the registration view.
     */
    public function create(): Response
    {
        $courses = Course::all();
        
        return Inertia::render('Auth/Register', [
            'courses' => $courses
        ]);
    }

    /**
     * Handle an incoming registration request.
     *
     * @throws \Illuminate\Validation\ValidationException
     */
    public function store(Request $request): RedirectResponse
    {
        $request->validate([
            'id_number' => 'required|string|max:20',
            'last_name' => 'required|string|max:150',
            'first_name' => 'required|string|max:150',
            'mid_name' => 'required|string|max:150',
            // 'email' => 'required|string|lowercase|email|max:255|unique:'.User::class,
            'email' => 'required|string|lowercase|email|max:255',
            'password' => ['required', 'confirmed', Rules\Password::defaults()],
        ]);

        $student = Student::where('id_number', $request->id_number)->first();

        if (empty($student)) {
            return back()->withErrors([
                'id_number' => 'ID Number not found on the system! Please contact your faculty to verify your data.',
            ]);
        } else {
            $user_id = $student->user_id;

            $name_ext = ($request->name_ext!=null) ? ' '.$request->name_ext : '';
            $name = $request->last_name.', '.$request->first_name.' '.$request->mid_name.$name_ext;
            
            $user = User::find($user_id);
            $user->update([
                'name' => $name,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'last_name' => strtoupper($request->last_name),
                'first_name' => $request->first_name,
                'mid_name' => $request->mid_name,
                'name_ext' => $request->name_ext,
            ]);

            Student::find($student->id)->update(['course_id' => $request->course_id]);

            event(new Registered($user));

            Auth::login($user);

            return redirect(route('dashboard', absolute: false));
        }

        // $user = User::create([
        //     'name' => $request->name,
        //     'email' => $request->email,
        //     'password' => Hash::make($request->password),
        // ]);

        // event(new Registered($user));

        // Auth::login($user);

        // return redirect(route('dashboard', absolute: false));
    }
}
