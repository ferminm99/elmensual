<?php

use Illuminate\Support\Facades\Route;
use App\Models\Articulo;
use App\Http\Controllers\ArticuloController;
use App\Http\Controllers\VentasController;
use App\Http\Controllers\CalendarioController;
use App\Http\Controllers\GoogleDriveController;
use App\Http\Middleware\CorsMiddleware;
use App\Http\Controllers\ClienteController;
use App\Http\Controllers\LocalidadController;
use App\Http\Controllers\Auth\LoginController;
// use App\Models\User;
use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken as Middleware;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Session;
use Illuminate\Support\Facades\Response;
use Symfony\Component\HttpFoundation\Cookie;
use App\Http\Middleware\VerifyCsrfToken;

App::make(Kernel::class)->prependMiddleware(VerifyCsrfToken::class);

// Rutas para cargar a google drive el excel
Route::get('/google/redirect', [GoogleDriveController::class, 'redirectToGoogle'])->name('google.redirect');
Route::get('/auth/google', [GoogleDriveController::class, 'redirectToGoogle'])->name('auth.google');
Route::get('/google/callback', [GoogleDriveController::class, 'handleGoogleCallback']);
Route::get('/upload-to-drive', [GoogleDriveController::class, 'uploadToDrive'])->name('drive.upload');


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

Route::get('/clientes', function () {
    return view('welcome'); // Vue se encargará de manejar la lógica interna
});

Route::get('/localidades', function () {
    return view('welcome');
});

Route::get('/comprascalendario', function () {
    return view('welcome'); // Vue se encargará de manejar la lógica interna
});

Route::group(['middleware' => 'cors'], function () {
    // Define tus rutas aquí
});

Route::get('/csrf-token', function () {
    $token = csrf_token();

    // Setear la cookie manualmente (NO usar Symfony Cookie aquí)
    setcookie(
        'XSRF-TOKEN',
        $token,
        [
            'expires' => time() + 3600,
            'path' => '/',
            'domain' => '.elmensual.vercel.app',
            'secure' => true,
            'httponly' => false, // 👈 clave
            'samesite' => 'None',
        ]
    );

    return Response::json(['token' => $token]);
});
Route::post('/login', [LoginController::class, 'login']);
Route::post('/logout', [LoginController::class, 'logout']);
Route::get('/check-auth', [LoginController::class, 'checkAuth']);


//Localidades
Route::get('/api/localidades', [LocalidadController::class, 'index']);
Route::post('/localidad', [LocalidadController::class, 'store']);
Route::put('/localidad/{id}', [LocalidadController::class, 'update']);
Route::delete('/localidad/{id}', [LocalidadController::class, 'destroy']);



//Articulos
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


//Ventas
Route::post('/ventas', [VentasController::class, 'registrarVenta']);
Route::get('/ventas/listar', [VentasController::class, 'obtenerVentas']);
Route::put('/ventas/{id}', [VentasController::class, 'update']);
Route::post('/ventas/cambiar-bombachas', [VentasController::class, 'cambiarBombacha']);
Route::delete('/ventas/{id}', [VentasController::class, 'destroy']);
// Facturaciones
Route::post('/facturaciones/guardar', [VentasController::class, 'guardarFacturaciones']);
Route::get('/facturaciones/ultima', [VentasController::class, 'obtenerUltimaFacturacion']);


//Calendario
Route::get('/comprascalendario/listar', [CalendarioController::class, 'index']);
Route::post('/comprascalendario', [CalendarioController::class, 'store']);
Route::put('/comprascalendario/{id}', [CalendarioController::class, 'update']);
Route::delete('/comprascalendario/{id}', [CalendarioController::class, 'destroy']);

//Clientes
Route::get('/clientes/listar', [ClienteController::class, 'index']); // Obtener todos los clientes
Route::post('/cliente', [ClienteController::class, 'store']); // Crear un cliente
Route::put('/cliente/{id}', [ClienteController::class, 'update']); // Actualizar un cliente
Route::delete('/cliente/{id}', [ClienteController::class, 'destroy']); // Eliminar un cliente


Route::get('{any}', function () {
    return File::get(public_path() . '/index.html');
})->where('any', '.*');