<?php

    namespace Database\Migrations;
    use Illuminate\Database\Migrations\Migration;
    use Illuminate\Database\Schema\Blueprint;
    use Illuminate\Support\Facades\Schema;

    class CreateVentasTable extends Migration {
        public function up() {
            Schema::create('ventas', function (Blueprint $table) {
                $table->bigIncrements('id');
                $table->unsignedBigInteger('articulo_id');
                $table->integer('cantidad');
                $table->decimal('precio', 10, 2);
                $table->unsignedBigInteger('cliente_id');
                $table->timestamps();

                // Foreign keys
                $table->foreign('articulo_id')->references('id')->on('articulos');
                $table->foreign('cliente_id')->references('id')->on('clientes');
            });
        }

        public function down() {
            Schema::dropIfExists('ventas');
        }
    }
    