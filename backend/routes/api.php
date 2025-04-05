<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ArticuloController;
use App\Http\Controllers\VentasController;
use App\Http\Controllers\CalendarioController;
use App\Http\Controllers\GoogleDriveController;
use App\Http\Controllers\ClienteController;
use App\Http\Controllers\LocalidadController;
use App\Http\Controllers\Auth\LoginController;
use Laravel\Sanctum\Http\Middleware\EnsureFrontendRequestsAreStateful;

// CSRF Token (usado por el frontend antes del login)
Route::get('/csrf-token', function () {
    return response()->json(['token' => csrf_token()]);
});

// Autenticación
Route::middleware([
    EnsureFrontendRequestsAreStateful::class,
    'web'
])->group(function () {
    Route::post('/login', [LoginController::class, 'login']);
});
Route::post('/logout', [LoginController::class, 'logout']);
Route::get('/check-auth', [LoginController::class, 'checkAuth']);

// Google Drive
Route::get('/google/redirect', [GoogleDriveController::class, 'redirectToGoogle'])->name('google.redirect');
Route::get('/auth/google', [GoogleDriveController::class, 'redirectToGoogle'])->name('auth.google');
Route::get('/google/callback', [GoogleDriveController::class, 'handleGoogleCallback']);
Route::get('/upload-to-drive', [GoogleDriveController::class, 'uploadToDrive'])->name('drive.upload');

// Artículos
Route::get('/articulos', [ArticuloController::class, 'index']);
Route::post('/articulo', [ArticuloController::class, 'store']);
Route::put('/articulo/{id}', [ArticuloController::class, 'update']);
Route::delete('/articulo/{id}', [ArticuloController::class, 'destroy']);
Route::get('/articulos/listar', [ArticuloController::class, 'listarArticulos']);
Route::get('/articulo/{id}', [ArticuloController::class, 'mostrarArticulo']);
Route::get('/articulo/listar/talles', [ArticuloController::class, 'listarArticulosConTalles']);
Route::post('/articulo/{id}/agregar-bombachas', [ArticuloController::class, 'agregarBombachas']);
Route::post('/articulo/{id}/eliminar-bombachas', [ArticuloController::class, 'eliminarBombachas']);
Route::post('/articulo/{id}/editar-bombachas', [ArticuloController::class, 'editarBombachas']);
Route::post('/articulo/{id}/eliminar-talle-completo', [ArticuloController::class, 'eliminarTalleCompleto']);
Route::put('/articulos/recalcular-precios', [ArticuloController::class, 'recalcularPreciosMasivamente']);
Route::put('/articulos/aumentar-costos', [ArticuloController::class, 'aumentarCostoOriginal']);

// Ventas
Route::post('/ventas', [VentasController::class, 'registrarVenta']);
Route::get('/ventas/listar', [VentasController::class, 'obtenerVentas']);
Route::put('/ventas/{id}', [VentasController::class, 'update']);
Route::post('/ventas/cambiar-bombachas', [VentasController::class, 'cambiarBombacha']);
Route::delete('/ventas/{id}', [VentasController::class, 'destroy']);
Route::post('/facturaciones/guardar', [VentasController::class, 'guardarFacturaciones']);
Route::get('/facturaciones/ultima', [VentasController::class, 'obtenerUltimaFacturacion']);

// Calendario
Route::get('/comprascalendario/listar', [CalendarioController::class, 'index']);
Route::post('/comprascalendario', [CalendarioController::class, 'store']);
Route::put('/comprascalendario/{id}', [CalendarioController::class, 'update']);
Route::delete('/comprascalendario/{id}', [CalendarioController::class, 'destroy']);

// Clientes
Route::get('/clientes/listar', [ClienteController::class, 'index']);
Route::post('/cliente', [ClienteController::class, 'store']);
Route::put('/cliente/{id}', [ClienteController::class, 'update']);
Route::delete('/cliente/{id}', [ClienteController::class, 'destroy']);

// Localidades
Route::get('/localidades', [LocalidadController::class, 'index']);
Route::post('/localidad', [LocalidadController::class, 'store']);
Route::put('/localidad/{id}', [LocalidadController::class, 'update']);
Route::delete('/localidad/{id}', [LocalidadController::class, 'destroy']);

// Para debug
Route::get('/session-id', function () {
    return response()->json(['session_id' => session()->getId()]);
});