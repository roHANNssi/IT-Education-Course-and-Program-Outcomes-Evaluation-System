<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Faculty extends Model
{
    protected $fillable = ['user_id', 'college_id', 'semester_id', 'designation', 'course_id', 'status'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
