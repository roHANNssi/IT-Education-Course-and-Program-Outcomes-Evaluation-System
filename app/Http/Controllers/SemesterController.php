<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;
use App\Models\Semester;

class SemesterController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $semesters = Semester::orderBy('order_num', 'DESC')->get();
        
        return Inertia::render('Setting/Semester', [
            'semesters' => $semesters,
        ]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'sem' => 'required',
            'acad_year' => 'required',
            'status' => 'required|in:active,inactive',
        ]);

        $exists = Semester::where('sem', $request->sem)
                    ->where('acad_year', $request->acad_year)
                    ->exists();
        $latest = Semester::select('order_num')
                    ->orderBy('order_num','DESC')
                    ->first();

        $order_num = (!empty($latest)) ? $latest->order_num + 1 : 1;

        if ($exists) {
            return back()->withErrors([
                'acad_year' => 'Semester already exist!',
            ]);
        }

        if ($request->status == 'active') {
            Semester::where('status', 'active')->update(['status' => 'inactive']);
        }

        Semester::create([
            'sem' => $request->sem,
            'acad_year' => $request->acad_year,
            'order_num' => $order_num,
            'status' => $request->status,
        ]);

        return redirect()->back()->with('success', 'Semester successfully saved!');
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $validated = $request->validate([
            'sem' => 'required',
            'acad_year' => 'required',
            'status' => 'required|in:active,inactive',
        ]);

        if ($request->status == 'active') {
            Semester::where('status', 'active')->update(['status' => 'inactive']);
        }

        Semester::find($id)->update([
            'sem' => $request->sem,
            'acad_year' => $request->acad_year,
            'status' => $request->status,
        ]);

        return redirect()->back()->with('success', 'Semester successfully updated!');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
