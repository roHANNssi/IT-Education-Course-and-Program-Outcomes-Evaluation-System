<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class FacultySubject extends Model
{
    protected $fillable = ['faculty_id', 'semester_id', 'subject_id', 'section'];
}
