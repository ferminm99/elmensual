<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return response()->json(['ok' => true]);
});


Route::get('/prueba-viva', fn() => '🔥 Laravel responde correctamente');