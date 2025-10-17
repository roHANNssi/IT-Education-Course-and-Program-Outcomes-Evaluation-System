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
        Schema::create('faculty_subjects', function (Blueprint $table) {
            $table->id();
            $table->integer('faculty_id');
            $table->integer('semester_id');
            $table->integer('subject_id');
            $table->char('section', 20);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('faculty_subjects');
    }
};
