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
        Schema::create('rating_settings', function (Blueprint $table) {
            $table->id();
            $table->integer('semester_id');
            $table->integer('subject_id');
            $table->tinyInteger('scale_version');
            $table->tinyInteger('co_version');
            $table->enum('status', ['active', 'inactive']);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('rating_settings');
    }
};
