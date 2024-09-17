<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateCompraCalendariosTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('compras_calendario', function (Blueprint $table) {
            $table->id();
            $table->string('nombre_persona');
            $table->unsignedBigInteger('articulo_id'); // Definimos articulo_id como unsignedBigInteger
            $table->string('talle', 10);
            $table->string('color', 20);
            $table->date('fecha');
            $table->time('hora_inicio');
            $table->time('hora_fin');
            $table->timestamps();

            // Definimos la clave foránea
            $table->foreign('articulo_id')->references('id')->on('articulos')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('compras_calendario');
    }
}