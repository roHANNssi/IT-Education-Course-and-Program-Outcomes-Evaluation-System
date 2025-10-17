<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Curriculum extends Model
{
    protected $fillable = ['course_id', 'curr_name', 'curr_detail', 'curr_stat'];

    public function getCurriculum($curriculum_id)
    {
        $curriculum = $this->select('curricula.*', 'courses.course_code', 'courses.course_name')->join('courses', 'courses.id', 'curricula.course_id')->where('curricula.id', $curriculum_id)->first();
        return $curriculum;
    }
}
