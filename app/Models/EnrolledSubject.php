<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class EnrolledSubject extends Model
{
    protected $fillable = ['enrollment_id', 'faculty_subject_id'];

    public function enrollment()
    {
        $this->belongsTo(Enrollment::class);
    }

    public function evaluation()
    {
        return $this->hasOne(Evaluation::class, 'enrolled_subject_id');    
    }

    public function evaluations()
    {
        return $this->hasMany(Evaluation::class, 'enrolled_subject_id');    
    }

    public function evaluation_comment()
    {
        return $this->hasOne(EvaluationComment::class, 'enrolled_subject_id');    
    }
}
