<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return redirect(env('VITE_APP_URL', 'https://elmensual.vercel.app'));
});