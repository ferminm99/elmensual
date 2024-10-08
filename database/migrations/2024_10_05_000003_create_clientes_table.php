<?php

    namespace Database\Migrations;
    use Illuminate\Database\Migrations\Migration;
    use Illuminate\Database\Schema\Blueprint;
    use Illuminate\Support\Facades\Schema;

    class CreateClientesTable extends Migration {
        public function up() {
            Schema::create('clientes', function (Blueprint $table) {
                $table->bigIncrements('id');
                $table->string('dni')->nullable();
                $table->string('nombre');
                $table->string('apellido');
                $table->string('cbu')->nullable();
                $table->timestamps();
            });
        }

        public function down() {
            Schema::dropIfExists('clientes');
        }
    }
    