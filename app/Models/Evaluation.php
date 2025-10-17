<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Evaluation extends Model
{
    protected $fillable = ['semester_id', 'subject_id', 'course_outcome_id', 'student_id', 'enrolled_subject_id', 'rating_setting_id', 'rating'];

    public function outcome_links()
    {
        return $this->hasMany(OutcomeLink::class, 'course_outcome_id');
    }
}
