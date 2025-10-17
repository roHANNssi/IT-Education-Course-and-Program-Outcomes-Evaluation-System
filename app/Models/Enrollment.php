<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Enrollment extends Model
{
    protected $fillable = ['student_id', 'semester_id', 'year_level', 'section', 'course_major_id'];

    public function student()
    {
        return $this->belongsTo(Student::class);
    }

    public function enrolled_subjects()
    {
        return $this->hasMany(EnrolledSubject::class, 'enrollment_id');    
    }

    public function getEnrollment($id)
    {
        return Enrollment::select('enrollments.*', 'semesters.sem', 'semesters.acad_year', 'course_majors.course_major')
            ->join('semesters', 'semesters.id', 'enrollments.semester_id')
            ->leftJoin('course_majors', 'course_majors.id', 'enrollments.course_major_id')
            ->where('enrollments.id', $id)
            ->first();
    }
}
