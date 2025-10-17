<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Course extends Model
{
    protected $fillable = ['college_id', 'course_name', 'course_code', 'status'];

    public function curricula()
    {
        return $this->hasMany(Curriculum::class, 'course_id');
    }
}
