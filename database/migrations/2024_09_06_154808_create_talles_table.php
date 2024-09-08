<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up()
    {
        Schema::create('talles', function (Blueprint $table) {
            $table->id();
            $table->integer('talle');
            $table->integer('marron')->default(0);
            $table->integer('negro')->default(0);
            $table->integer('verde')->default(0);
            $table->integer('azul')->default(0);
            $table->integer('celeste')->default(0);
            $table->integer('blancobeige')->default(0);
            $table->foreignId('articulo_id')->constrained('articulos')->onDelete('cascade');
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('talles');
    }

};