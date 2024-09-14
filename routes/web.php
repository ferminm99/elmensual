<?php

use Illuminate\Support\Facades\Route;
use App\Models\Articulo;
use App\Http\Controllers\ArticuloController;
use App\Http\Controllers\VentasController;

// Ruta para la vista Home
Route::get('/', function () {
    return view('welcome'); // Asegúrate de que `welcome.blade.php` tenga el contenedor para tu aplicación Vue
});

// Ruta para la vista de Artículos (ManageArticulos)
Route::get('/managearticulos', function () {
    return view('welcome'); // La misma vista que carga Vue, pero se encargará de renderizar el componente de artículos
});

// Ruta para la vista de Ventas
Route::get('/ventas', function () {
    return view('welcome'); // Vue se encargará de manejar la lógica interna
});

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

//Ventas
Route::post('/ventas', [VentasController::class, 'registrarVenta']);
Route::get('/ventas/listar', [VentasController::class, 'obtenerVentas']);
Route::put('/ventas/{id}', [VentasController::class, 'update']);
Route::post('/ventas/cambiar-bombachas', [VentasController::class, 'cambiarBombacha']);
Route::delete('/ventas/{id}', [VentasController::class, 'destroy']);

Route::get('/{pathMatch}', function () {
    return view('welcome');
})->where('/{pathMatch}','.*');