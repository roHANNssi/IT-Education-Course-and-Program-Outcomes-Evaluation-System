<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Setting extends Model
{
    protected $fillable = ['semester_id', 'type', 'course_id', 'curriculum_id', 'version', 'created_by', 'updated_by'];

    public function settingType($st = null)
    {
        $setting_types = ['curriculum' => 'Curriculum', 'program-outcome' => 'Program Outcome'];
        return $st ? ($setting_types[$st] ?? null) : $setting_types;
    }

    public static function typeValidationRules(): array
    {
        return [
            'curriculum' => [
                'course_id' => 'required|integer|exists:courses,id',
                'curriculum_id' => 'required|integer|exists:curricula,id',
            ],
            'program-outcome' => [
                'course_id' => 'required|integer|exists:courses,id',
                'version' => 'required|integer|min:1',
            ],
            // Future types:
            // 'faculty' => ['faculty_id' => 'required|integer|exists:faculties,id'],
        ];
    }
}
