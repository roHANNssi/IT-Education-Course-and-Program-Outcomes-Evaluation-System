<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CourseOutcome extends Model
{
    protected $fillable = ['subject_id', 'version', 'order_no', 'course_outcome', 'status'];

    public function outcome_links()
    {
        return $this->hasMany(OutcomeLink::class, 'course_outcome_id');    
    }

    public function evaluations()
    {
        return $this->hasMany(Evaluation::class, 'course_outcome_id');    
    }

    public function getVersion($subject_id, $vtype = 'new')
    {
        $course_outcome = $this->select('version')->where('subject_id', $subject_id)->orderBy('version', 'DESC')->first();
        if ($vtype == 'latest') {
            if (!empty($course_outcome)) {
                return $course_outcome->version;
            } else {
                return null;
            }
        } else {
            if (!empty($course_outcome)) {
                return $course_outcome->version + 1;
            } else {
                return 1;
            }
        }
    }

    public function getNextOrderNo($subject_id, $version)
    {
        $course_outcome = $this->select('order_no')->where('subject_id', $subject_id)->where('version', $version)->orderBy('order_no', 'DESC')->first();
        if (!empty($course_outcome)) {
            return $course_outcome->order_no + 1;
        } else {
            return 1;
        }
    }
}
