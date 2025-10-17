<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Subject extends Model
{
    protected $fillable = ['course_id', 'curriculum_id', 'course_major_id', 'subject_type', 'subject_code', 'subject_title', 'yr_level', 'status'];

    public function course_outcomes()
    {
        return $this->hasMany(CourseOutcome::class, 'subject_id');
    }

    public function rating_setting()
    {
        return $this->hasOne(RatingSetting::class, 'subject_id');
    }

    public function faculty_subjects()
    {
        return $this->hasMany(FacultySubject::class, 'subject_id');
    }

    public function evaluations()
    {
        return $this->hasMany(Evaluation::class, 'subject_id');
    }

    public function subjectType($st = null)
    {
        $arr_st = ['major' => 'Major', 'gen-ed' => 'General Education'];
        if ($st != null) {
            foreach ($arr_st as $key => $val) {
                if ($st == $key) {
                    return $val;
                }
            }
        } else {
            return $arr_st;
        }
    }
}
