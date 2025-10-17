<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class EvaluationSchedule extends Model
{
    protected $fillable = ['semester_id', 'course_id', 'start_date', 'end_date'];
}
