<?php

namespace App\Http\Controllers;

use App\Models\Articulo;
use App\Models\Venta;
use App\Models\Cliente;
use App\Models\Talle;
use Carbon\Carbon;

use Illuminate\Http\Request; 

class VentasController extends Controller
{
    public function registrarVenta(Request $request) {
        // Registrar al cliente si no existe, buscando por nombre y apellido
        $cliente = Cliente::firstOrCreate(
            [
                'nombre' => $request->cliente_nombre,
                'apellido' => $request->cliente_apellido
            ],
            [
                'cuit' => $request->cliente_cuit,
                'cbu' => $request->cliente_cbu
            ]
        );
        

        // Registrar cada producto en la venta
        foreach ($request->productos as $producto) {
            // logger()->info('Producto recibido:', ['producto' => $producto]);
            // $costoOriginal = floatval($producto['costo_original']);

            // Crear una venta por cada producto
            Venta::create([
                'articulo_id' => $producto['articulo']['id'],
                'cliente_id' => $cliente->id,
                'talle' => $producto['talle'],
                'color' => $producto['color'],
                'precio' => $producto['precio'],
                'fecha' => $request->fecha,
                'forma_pago' => $request->forma_pago,
                'costo_original' => $producto['costo_original'],
            ]);
    
            // Actualizar el stock del artículo
            $articulo = Articulo::find($producto['articulo']['id']);
            $articulo->talles()->where('talle', $producto['talle'])->decrement($producto['color'], 1);
        }
    
        return response()->json(['message' => 'Venta registrada exitosamente']);
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
        // Validar la entrada
        $request->validate([
            'precio' => 'required|numeric|min:0',
            'costo_original' => 'required|numeric|min:0',
            'fecha' => 'required|date', // Validar que la fecha sea una fecha válida
            'forma_pago' => 'required|in:efectivo,transferencia', // Validar que la forma de pago sea una de las opciones permitidas
        ]);

        // Buscar la venta por ID
        $venta = Venta::findOrFail($id);

        // Actualizar los campos
        $venta->precio = $request->precio;
        $venta->fecha = $request->fecha;
        $venta->forma_pago = $request->forma_pago;
        $venta->costo_original = $request->costo_original;

        // Guardar los cambios en la base de datos
        $venta->save();

        return response()->json(['message' => 'Venta actualizada exitosamente']);
    }

 
     // Eliminar una venta
     public function destroy($id)
    {
        // Buscar la venta por ID
        $venta = Venta::findOrFail($id);

        // Obtener el cliente asociado a la venta
        $cliente = $venta->cliente;

        //Como elimine la venta recupero el articulo vendido!
        $articulo = Articulo::find($venta['articulo']['id']);
        $articulo->talles()->where('talle', $venta['talle'])->increment($venta['color'], 1);
        
        // Eliminar la venta
        $venta->delete();

        // Verificar si el cliente tiene otras ventas
        if ($cliente->ventas()->count() === 0) {
            // Si no tiene más ventas, eliminar el cliente
            $cliente->delete();
        }

            
        return response()->json(['message' => 'Venta eliminada exitosamente']);
    }

    public function cambiarBombacha(Request $request)
    {
        
        // Obtener la venta
        $venta = Venta::findOrFail($request->venta_id);

        if (!$venta) {
            return response()->json(['error' => 'Venta no encontrada.'], 404);
        }

        // Reponer la bombacha original
        $articuloOriginal = Articulo::find($request->original['articulo_id']);
        $talleOriginal = $articuloOriginal->talles()->where('talle', $request->original['talle'])->first();
        $talleOriginal->increment($request->original['color'], 1);

        // Restar la nueva bombacha seleccionada
        $articuloNuevo = Articulo::find($request->nueva['articulo_id']);
        $talleNuevo = $articuloNuevo->talles()->where('talle', $request->nueva['talle'])->first();
        $talleNuevo->decrement($request->nueva['color'], 1);

        // Mantener los valores existentes si no se proporcionan en la solicitud
        $venta->update([
            'articulo_id' => $request->nueva['articulo_id'] ?? $venta->articulo_id,
            'talle' => $request->nueva['talle'] ?? $venta->talle,
            'color' => $request->nueva['color'] ?? $venta->color,
            'precio' => $venta->precio, // Mantén el precio si no cambias
            'costo_original' => $venta->costo_original, // Mantén el costo original si no cambias
            'fecha' => $venta->fecha, // Mantén la fecha si no cambias
            'forma_pago' => $venta->forma_pago, // Mantén la forma de pago si no cambias
        ]);

        return response()->json(['message' => 'Cambio de bombacha realizado con éxito.']);
    }

}