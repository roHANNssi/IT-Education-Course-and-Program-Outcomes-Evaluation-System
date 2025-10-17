<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class RatingSetting extends Model
{
    protected $fillable = ['semester_id', 'subject_id', 'scale_version', 'co_version', 'status'];
}
