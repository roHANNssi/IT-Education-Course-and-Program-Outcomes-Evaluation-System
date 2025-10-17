<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CourseMajor extends Model
{
    protected $fillable = ['course_id', 'course_major', 'year_level', 'status'];
}
