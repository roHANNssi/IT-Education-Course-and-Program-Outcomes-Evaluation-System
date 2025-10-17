<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class OutcomeLink extends Model
{
    protected $fillable = ['course_outcome_id', 'program_outcome_id'];

    public function courseOutcome()
    {
        return $this->belongsTo(CourseOutcome::class, 'course_outcome_id');
    }

    public function programOutcome()
    {
        return $this->belongsTo(ProgramOutcome::class, 'program_outcome_id');
    }
}
