<?php

namespace App\Http\Controllers;

use App\Models\Articulo;
use App\Models\Venta;
use App\Models\Cliente;
use App\Models\Talle;
use Carbon\Carbon;
use App\Models\Facturacion; // Importamos el modelo Facturacion
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Traits\ActualizaMetaTrait;

use Illuminate\Http\Request; 

class VentasController extends Controller
{
    use ActualizaMetaTrait;
    public function registrarVenta(Request $request) {

        // Normalizamos el nombre y apellido: primera letra en mayúscula, el resto en minúsculas
        $nombre = $request->cliente_nombre;
        $apellido = $request->cliente_apellido;
    
        // Intentar primero buscar por nombre y apellido
        $cliente = Cliente::where('nombre', $nombre)
            ->where('apellido', $apellido)
            ->first();
    
        // Si no se encontró por nombre y apellido, intentamos buscar por CUIT o CBU solo si no están vacíos
        if (!$cliente && (!empty($request->cliente_cuit) || !empty($request->cliente_cbu))) {
            $cliente = Cliente::where(function ($query) use ($request) {
                if (!empty($request->cliente_cuit)) {
                    $query->where('cuit', $request->cliente_cuit);
                }
    
                if (!empty($request->cliente_cbu)) {
                    $query->orWhere('cbu', $request->cliente_cbu);
                }
            })->first();
    
            // Si lo encontramos por CUIT o CBU, actualizamos el nombre y apellido
            if ($cliente) {
                $updateData = [
                    'nombre' => $nombre,
                    'apellido' => $apellido,
                ];
    
                // Solo actualizamos el CUIT si no está asignado previamente
                if (empty($cliente->cuit) && !empty($request->cliente_cuit)) {
                    $updateData['cuit'] = $request->cliente_cuit;
                }
    
                // Solo actualizamos el CBU si no está asignado previamente
                if (empty($cliente->cbu) && !empty($request->cliente_cbu)) {
                    $updateData['cbu'] = $request->cliente_cbu;
                }
    
                // Actualizar los datos del cliente
                $cliente->update($updateData);
            }
        }
    
        // Si no encontramos ningún cliente, lo creamos
        if (!$cliente) {
            $cliente = Cliente::create([
                'nombre' => $nombre,
                'apellido' => $apellido,
                'cuit' => $request->cliente_cuit,
                'cbu' => $request->cliente_cbu,
            ]);
        }
    
        // Lista para guardar las ventas registradas
        $ventasRegistradas = [];
        // Registrar cada producto en la venta
        foreach ($request->productos as $producto) {
            // Crear una venta por cada producto
            $venta = Venta::create([
                'articulo_id' => $producto['articulo']['id'],
                'cliente_id' => $cliente->id,
                'talle' => $producto['talle'],
                'color' => $producto['color'],
                'precio' => $producto['precio'],
                'fecha' => $request->fecha,
                'forma_pago' => $request->forma_pago,
                'costo_original' => $producto['costo_original'],
            ]);
            
            $articulo = Articulo::find($producto['articulo']['id']);
            $articulo->talles()->where('talle', $producto['talle'])->decrement($producto['color'], 1);
            
            // Cargar relaciones
            $venta->load('articulo', 'cliente');
            
            $ventasRegistradas[] = $venta;
            
        }
    
        return response()->json([
            'ventas' => $ventasRegistradas,
            'last_update' => now()->timestamp * 1000, // en milisegundos
        ], 201);
        
    }

    //Obtiene la ultima facturacion
    public function obtenerUltimaFacturacion()
    {
        $ultimaFacturacion = Facturacion::latest('fecha_facturacion')->first();
        return response()->json($ultimaFacturacion);
    }

    public function guardarFacturaciones(Request $request)
    {
        $ventas = $request->ventas;
        $ultimaVentaId = null;

        foreach ($ventas as $venta) {
            // Crear una nueva entrada en la tabla facturaciones
            $facturacion = Facturacion::create([
                'venta_id' => $venta['id'],
                'fecha_facturacion' => now(),
            ]);

            $ultimaVentaId = $facturacion->venta_id;
        }

        $lastUpdate = Venta::latest('updated_at')->first()?->updated_at->timestamp * 1000;

        return response()->json([
            'message' => 'Facturaciones guardadas con éxito',
            'ultima_venta_id' => $ultimaVentaId,
            'last_update' => $lastUpdate,
        ]);

    }
    // Obtener las ventas para visualizarlas
    public function obtenerVentas()
    {
        $ventas = Venta::with('articulo', 'cliente')->get();
        return response()->json($ventas);
    }

     // Actualizar el precio de una venta
     public function update(Request $request, $id)
    {
        $request->validate([
            'precio' => 'required|numeric|min:0',
            'costo_original' => 'required|numeric|min:0',
            'fecha' => 'required|date',
            'forma_pago' => 'required|in:efectivo,transferencia',
        ]);

        $venta = Venta::findOrFail($id);

        $venta->update([
            'precio' => $request->precio,
            'fecha' => $request->fecha,
            'forma_pago' => $request->forma_pago,
            'costo_original' => $request->costo_original,
        ]);

        $venta->touch();
        // Cargar relaciones para que el frontend reciba la venta completa
        $venta->load('articulo', 'cliente');

        return response()->json([
            'venta' => $venta,
            'last_update' => now()->timestamp * 1000,
        ]);
        
    }


 
    // Eliminar una venta
    public function destroy($id)
    {
        try {
            $venta = Venta::findOrFail($id);
            $cliente = $venta->cliente;

            $articulo = Articulo::find($venta['articulo']['id']);
            $articulo->talles()->where('talle', $venta['talle'])->increment($venta['color'], 1);

            $venta->delete();

            // Si no quedan ventas del cliente, eliminarlo
            if ($cliente->ventas()->count() === 0) {
                $cliente->delete();
                $ultimoCliente = Cliente::latest()->first();
                if ($ultimoCliente) $ultimoCliente->touch();
            }

            $ultimaVenta = Venta::latest()->first();
            if ($ultimaVenta) $ultimaVenta->touch();

            $ultimoTalle = Talle::latest()->first();
            if ($ultimoTalle) $ultimoTalle->touch();

            return response()->json([
                'message' => 'Venta eliminada exitosamente',
                'deleted_id' => $venta->id, 
                'last_update' => now()->timestamp * 1000,
            ]);
            
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json(['error' => 'La venta no existe'], 404);
        }
    }




    public function cambiarBombacha(Request $request)
    {
        $venta = Venta::findOrFail($request->venta_id);

        if (!$venta) {
            return response()->json(['error' => 'Venta no encontrada.'], 404);
        }

        // Reponer la bombacha original
        $articuloOriginal = Articulo::find($request->original['articulo_id']);
        $talleOriginal = $articuloOriginal->talles()->where('talle', $request->original['talle'])->first();
        $talleOriginal->increment($request->original['color'], 1);

        // Descontar la nueva bombacha
        $articuloNuevo = Articulo::find($request->nueva['articulo_id']);
        $talleNuevo = $articuloNuevo->talles()->where('talle', $request->nueva['talle'])->first();
        $talleNuevo->decrement($request->nueva['color'], 1);

        // Actualizar la venta con los nuevos valores
        $venta->update([
            'articulo_id' => $request->nueva['articulo_id'],
            'talle' => $request->nueva['talle'],
            'color' => $request->nueva['color'],
            'precio' => $request->precio,
            'costo_original' => $request->costo_original,
            'fecha' => $request->fecha,
            'forma_pago' => $request->forma_pago,
        ]);

        $venta->touch();
        // Recargar relaciones para devolver todo completo
        $venta->load('articulo', 'cliente');

        return response()->json([
            'venta' => $venta,
            'last_update' => now()->timestamp * 1000,
        ]);
    }

    public function ultimaActualizacionVentas() {
        $lastUpdate = DB::table('ventas')->max('updated_at');
        return response()->json(['last_update' => strtotime($lastUpdate)]);
    }
    
    public function ventasActualizadasDesde(Request $request)
    {
        try {
            $timestamp = $request->query('timestamp');
            if (!$timestamp || !is_numeric($timestamp)) {
                return response()->json(['error' => 'Falta el parámetro timestamp'], 400);
            }
    
            $desde = \Carbon\Carbon::createFromTimestamp(floor($timestamp / 1000));
    
            $ventas = Venta::with('articulo', 'cliente')
                ->where('updated_at', '>', $desde)
                ->get();
    
            $lastUpdate = DB::table('ventas')->max('updated_at') ?? now();
    
            return response()->json([
                'data' => $ventas,
                'count' => $ventas->count(),
                'last_update' => strtotime($lastUpdate),
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Error al obtener ventas actualizadas: ' . $e->getMessage(),
            ], 500);
        }
    }
    

        

}