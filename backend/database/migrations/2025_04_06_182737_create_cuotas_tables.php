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
        Schema::create('cuotas', function (Blueprint $table) {
            $table->id();
            $table->boolean('es_con_interes')->default(false);
            $table->unsignedInteger('cantidad_cuotas');
            $table->decimal('factor_total', 8, 4);
            $table->timestamps();
            $table->unique(['es_con_interes', 'cantidad_cuotas', 'factor_total'], 'cuotas_unicas');
        });

        Schema::create('articulo_cuota', function (Blueprint $table) {
            $table->id();
            $table->foreignId('articulo_id')->constrained('articulos')->cascadeOnDelete();
            $table->foreignId('cuota_id')->constrained('cuotas')->cascadeOnDelete();
            $table->timestamps();
            $table->unique(['articulo_id', 'cuota_id']);
        });

        Schema::table('ventas', function (Blueprint $table) {
            $table->foreign('cuota_id')->references('id')->on('cuotas')->nullOnDelete();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('ventas', function (Blueprint $table) {
            $table->dropForeign(['cuota_id']);
        });

        Schema::dropIfExists('articulo_cuota');
        Schema::dropIfExists('cuotas');
    }
};