<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;
use App\Models\Scale;

class ScaleController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index($version = null)
    {   
        $_scale = new Scale;
        
        $lastest_version = $_scale->getVersion('latest');
        $versions = Scale::select('scales.version')->groupBy('version')->orderBy('version', 'ASC')->get();
        $version = ($version!=null) ? $version : $lastest_version;
        $new_version = $lastest_version + 1;
        
        $scales = Scale::where('scales.version', $version)->orderBy('rating', 'DESC')->get();

        return Inertia::render('Setting/Scale', [
            'version' => $version,
            'versions' => $versions,
            'scales' => $scales,
            'new_version' => $new_version,
        ]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        $_scale = new Scale;

        // $new_version = $_scale->getVersion();
        // return Inertia::render('Scale/Create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'rating' => 'required|numeric',
            'descriptive_rating' => 'required',
        ]);

        $exists = Scale::where('version', $request->version)
                    ->where('rating', $request->rating)
                    ->exists();

        if ($exists) {
            return back()->withErrors([
                'rating' => 'Scale version and rating already exist!',
            ]);
        }

        Scale::create($validated + ['version' => $request->version]);

        return redirect()->back()->with('success', 'Scale successfully saved!');
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $validated = $request->validate([
            'rating' => 'required|numeric',
            'descriptive_rating' => 'required',
        ]);

        Scale::find($id)->update([
            'rating' => $request->rating,
            'descriptive_rating' => $request->descriptive_rating,
        ]);

        return redirect()->back()->with('success', 'Scale successfully updated!');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
