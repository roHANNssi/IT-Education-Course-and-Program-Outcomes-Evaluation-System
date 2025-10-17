<?php

namespace App\Http\Middleware;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth; //added
use Inertia\Middleware;

class HandleInertiaRequests extends Middleware
{
    /**
     * The root template that is loaded on the first page visit.
     *
     * @var string
     */
    protected $rootView = 'app';

    /**
     * Determine the current asset version.
     */
    public function version(Request $request): ?string
    {
        return parent::version($request);
    }

    /**
     * Define the props that are shared by default.
     *
     * @return array<string, mixed>
     */
    public function share(Request $request): array
    {
        return array_merge(parent::share($request), [
            'auth' => fn () => [
                'user' => Auth::user() ? [
                    'id'          => Auth::id(),
                    'name'        => Auth::user()->name,
                    'email'       => Auth::user()->email,
                    'role'        => Auth::user()->role,
                    'designation' => Auth::user()->role === 'faculty'
                                        ? optional(Auth::user()->facultyUser)->designation
                                        : null,
                    'college_id'  => Auth::user()->role === 'faculty'
                                        ? optional(Auth::user()->facultyUser)->college_id
                                        : null,
                    'semester_id' => Auth::user()->role === 'faculty'
                                        ? optional(Auth::user()->facultyUser)->semester_id
                                        : null,
                    'course_id' => Auth::user()->role === 'faculty'
                                        ? optional(Auth::user()->facultyUser)->course_id
                                        : null,
                ] : null,
            ],
        ]);

        // return [
        //     ...parent::share($request),
        //     'auth' => [
        //         'user' => $request->user(),
        //     ],
        // ];
    }
}
