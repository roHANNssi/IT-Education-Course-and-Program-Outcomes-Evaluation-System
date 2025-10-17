<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Semester extends Model
{
    protected $fillable = ['sem', 'acad_year', 'order_num', 'status'];

    public function getSemesters()
    {
        $semesters = Semester::orderBy('semesters.order_num', 'DESC')->get();
        return $semesters;
    }

    public function getByStatus($status = 'active')
    {
        return Semester::where('status', $status)->first();
    }
}
