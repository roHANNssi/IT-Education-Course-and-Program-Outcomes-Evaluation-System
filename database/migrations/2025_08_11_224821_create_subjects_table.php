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
        Schema::create('subjects', function (Blueprint $table) {
            $table->id();
            $table->integer('course_id');
            $table->integer('course_major_id')->nullble();
            $table->enum('subject_type', ['major', 'gen-ed']);
            $table->char('subject_code', 20);
            $table->string('subject_title', 150);
            $table->enum('yr_level', ['first', 'second', 'third', 'fourth']);
            $table->enum('status', ['active', 'inactive']);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('subjects');
    }
};
