<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('evaluations', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('semester_id');
            $table->unsignedBigInteger('subject_id');
            $table->unsignedBigInteger('course_outcome_id');
            $table->unsignedBigInteger('student_id');
            $table->unsignedBigInteger('enrolled_subject_id');
            $table->unsignedBigInteger('rating_setting_id');
            $table->float('rating', 5, 2);
            $table->timestamps();

            // Prevent duplicate evaluations
            $table->unique(
                ['semester_id', 'course_outcome_id', 'student_id'],
                'unique_eval'
            );
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('evaluations');
    }
};
