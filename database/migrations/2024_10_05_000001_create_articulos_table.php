<?php

    namespace Database\Migrations;
    use Illuminate\Database\Migrations\Migration;
    use Illuminate\Database\Schema\Blueprint;
    use Illuminate\Support\Facades\Schema;

    class CreateArticulosTable extends Migration {
        public function up() {
            Schema::create('articulos', function (Blueprint $table) {
                $table->bigIncrements('id');
                $table->integer('numero');
                $table->string('nombre');
                $table->decimal('precio', 10, 2);
                $table->decimal('costo_original', 10, 2);
                $table->timestamps();
            });
        }

        public function down() {
            Schema::dropIfExists('articulos');
        }
    }
    