<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class EvaluationComment extends Model
{
    protected $fillable = ['semester_id', 'subject_id', 'student_id', 'enrolled_subject_id', 'comment'];
}
