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
        Schema::create('ventas', function (Blueprint $table) {
            $table->id();
            $table->foreignId('articulo_id')->constrained('articulos');
            $table->foreignId('cliente_id')->constrained('clientes');
            $table->string('talle');
            $table->string('color');
            $table->decimal('precio', 12, 2);
            $table->decimal('costo_original', 12, 2);
            $table->date('fecha');
            $table->enum('forma_pago', ['efectivo', 'transferencia']);
            $table->unsignedBigInteger('cuota_id')->nullable();
            $table->unsignedInteger('cantidad_cuotas')->nullable();
            $table->decimal('total_financiado', 12, 2)->nullable();
            $table->decimal('importe_cuota', 12, 2)->nullable();
            $table->timestamps();

            $table->index(['fecha', 'forma_pago']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('ventas');
    }
};