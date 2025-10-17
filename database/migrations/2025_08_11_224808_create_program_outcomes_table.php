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
        Schema::create('program_outcomes', function (Blueprint $table) {
            $table->id();
            $table->integer('course_id');
            $table->tinyInteger('version');
            $table->char('po_code', 10);
            $table->text('po_description');
            $table->tinyInteger('order_number');
            $table->enum('status', ['active', 'inactive']);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('program_outcomes');
    }
};
