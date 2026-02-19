<?php
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ArticuloController;
use App\Http\Controllers\VentasController;
use App\Http\Controllers\CalendarioController;
use App\Http\Controllers\GoogleDriveController;
use App\Http\Controllers\ClienteController;
use App\Http\Controllers\LocalidadController;
use App\Http\Controllers\CuotaController;
use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\CriticalStockAlertController;
use App\Http\Controllers\ConfiguracionPrecioTramoController;
use App\Http\Middleware\TokenAuthMiddleware;
use Illuminate\Http\Request;

/**
 * ---------------------------
 * 🔓 Rutas públicas
 * ---------------------------
 */
Route::post('/login', [LoginController::class, 'login']);
Route::post('/logout', [LoginController::class, 'logout']);

// Opcional para debug
Route::get('/debug-error', fn () => response()->json(['debug' => 'OK']));





/**
 * ---------------------------
 * 🔐 Rutas protegidas con auth:sanctum
 * ---------------------------
 */
Route::middleware('token-auth')->group(function () {
    
    Route::get('/check-auth', [LoginController::class, 'checkAuth']);

    
    // Artículos
    Route::get('/articulos', [ArticuloController::class, 'index']);
    Route::post('/articulo', [ArticuloController::class, 'store']);
    Route::put('/articulo/{id}', [ArticuloController::class, 'update']);
    Route::delete('/articulo/{id}', [ArticuloController::class, 'destroy']);
    Route::get('/articulo/{id}', [ArticuloController::class, 'mostrarArticulo']);
    Route::get('/articulo/listar/talles', [ArticuloController::class, 'listarArticulosConTalles']);
    Route::post('/articulo/{id}/agregar-bombachas', [ArticuloController::class, 'agregarBombachas']);
    Route::post('/articulo/{id}/eliminar-bombachas', [ArticuloController::class, 'eliminarBombachas']);
    Route::post('/articulo/{id}/editar-bombachas', [ArticuloController::class, 'editarBombachas']);
    Route::post('/articulo/{id}/eliminar-talle-completo', [ArticuloController::class, 'eliminarTalleCompleto']);
    Route::get('/articulos/listar', [ArticuloController::class, 'listarArticulos']);
    Route::put('/articulos/recalcular-precios', [ArticuloController::class, 'recalcularPreciosMasivamente']);
    Route::put('/articulos/aumentar-costos', [ArticuloController::class, 'aumentarCostoOriginal']);
    Route::put('/articulos/ajustar-costo-original', [ArticuloController::class, 'ajustarCostoOriginal']);
    Route::post('/articulos/revertir-ajuste-costo-original', [ArticuloController::class, 'revertirAjusteCostoOriginal']);
    Route::get('/articulos/configuracion-aumentos', [ArticuloController::class, 'obtenerConfiguracionAumentos']);
    Route::get('/articulos/configuracion-tramos', [ConfiguracionPrecioTramoController::class, 'index']);
    Route::post('/articulos/configuracion-tramos', [ConfiguracionPrecioTramoController::class, 'store']);
    Route::put('/articulos/configuracion-tramos/{tramo}', [ConfiguracionPrecioTramoController::class, 'update']);
    Route::delete('/articulos/configuracion-tramos/{tramo}', [ConfiguracionPrecioTramoController::class, 'destroy']);
    Route::get('/articulos/ultima-actualizacion', [ArticuloController::class, 'ultimaActualizacionArticulos']);
    Route::get('/articulos/talles/ultima-actualizacion', [ArticuloController::class, 'ultimaActualizacionTallesArticulos']);
    Route::get('/articulos/actualizados-desde', [ArticuloController::class, 'articulosActualizadosDesde']);
    Route::get('/articulos/talles/actualizados-desde', [ArticuloController::class, 'articulosTallesActualizadosDesde']);

    Route::get('/alertas/criticas', [CriticalStockAlertController::class, 'index']);
    Route::post('/alertas/{alert}/vincular-pedido', [CriticalStockAlertController::class, 'vincularPedido']);
    Route::post('/alertas/{alert}/marcar-resuelto', [CriticalStockAlertController::class, 'marcarResuelto']);
    
    // Cuotas
    Route::get('/cuotas', [CuotaController::class, 'index']);
    Route::post('/cuotas', [CuotaController::class, 'store']);
    Route::put('/cuotas/{cuota}', [CuotaController::class, 'update']);
    Route::delete('/cuotas/{cuota}', [CuotaController::class, 'destroy']);
    
    // Ventas
    Route::post('/ventas', [VentasController::class, 'registrarVenta']);
    Route::post('/ventas/sin-stock', [VentasController::class, 'registrarVentaSinStock']);
    Route::get('/ventas/listar', [VentasController::class, 'obtenerVentas']);
    Route::put('/ventas/masivo', [VentasController::class, 'updateMultiple']);
    Route::put('/ventas/{id}', [VentasController::class, 'update']);
    Route::post('/ventas/cambiar-bombachas', [VentasController::class, 'cambiarBombacha']);
    Route::delete('/ventas/{id}', [VentasController::class, 'destroy']);
    Route::post('/facturaciones/guardar', [VentasController::class, 'guardarFacturaciones']);
    Route::get('/facturaciones/ultima', [VentasController::class, 'obtenerUltimaFacturacion']);
    Route::get('/ventas/ultima-actualizacion', [VentasController::class, 'ultimaActualizacionVentas']);
    Route::get('/ventas/actualizados-desde', [VentasController::class, 'ventasActualizadasDesde']);

    // Calendario
    Route::get('/comprascalendario/listar', [CalendarioController::class, 'index']);
    Route::post('/comprascalendario', [CalendarioController::class, 'store']);
    Route::put('/comprascalendario/{id}', [CalendarioController::class, 'update']);
    Route::delete('/comprascalendario/{id}', [CalendarioController::class, 'destroy']); 
    Route::get('/comprascalendario/ultima-actualizacion', [CalendarioController::class, 'ultimaActualizacionCalendario']);
    Route::get('/calendario/actualizados-desde', [CalendarioController::class, 'calendarioActualizadosDesde']);
    
    // Clientes
    Route::get('/clientes/listar', [ClienteController::class, 'index']);
    Route::post('/cliente', [ClienteController::class, 'store']);
    Route::put('/cliente/{id}', [ClienteController::class, 'update']);
    Route::delete('/cliente/{id}', [ClienteController::class, 'destroy']);
    Route::get('/clientes/ultima-actualizacion', [ClienteController::class, 'ultimaActualizacionClientes']);
    Route::get('/clientes/actualizados-desde', [ClienteController::class, 'clientesActualizadosDesde']);
    
    // Localidades
    Route::get('/localidades', [LocalidadController::class, 'index']);
    Route::post('/localidad', [LocalidadController::class, 'store']);
    Route::put('/localidad/{id}', [LocalidadController::class, 'update']);
    Route::delete('/localidad/{id}', [LocalidadController::class, 'destroy']);
    Route::get('/localidad/ultima-actualizacion', [LocalidadController::class, 'ultimaActualizacionLocalidades']);
    Route::get('/localidades/actualizados-desde', [LocalidadController::class, 'localidadesActualizadasDesde']);

    
    // Google Drive
    Route::get('/google/redirect', [GoogleDriveController::class, 'redirectToGoogle'])->name('google.redirect');
    Route::get('/auth/google', [GoogleDriveController::class, 'redirectToGoogle'])->name('auth.google');
    Route::get('/google/callback', [GoogleDriveController::class, 'handleGoogleCallback']);
    Route::get('/upload-to-drive', [GoogleDriveController::class, 'uploadToDrive'])->name('drive.upload');
});