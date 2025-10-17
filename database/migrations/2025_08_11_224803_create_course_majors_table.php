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
        Schema::create('course_majors', function (Blueprint $table) {
            $table->id();
            $table->integer('course_id');
            $table->string('course_major', 150);
            $table->enum('year_level', ['first', 'second', 'third', 'fourth']);
            $table->enum('status', ['active', 'inactive']);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('course_majors');
    }
};
