<?php

namespace App\Http\Controllers;

use App\Models\CompraCalendario;
use Illuminate\Http\Request; 

class CalendarioController extends Controller
{
    public function index()
    {
        // Listar todas las compras agendadas
        $compras = CompraCalendario::with('articulo')->get();
        return response()->json($compras);
    }
    
    public function store(Request $request)
    {
        // Crear la compra en la base de datos sin validar los datos entrantes
        $compra = new CompraCalendario();
        $compra->nombre_persona = $request->nombre_persona;
        $compra->articulo_id = $request->articulo_id;
        $compra->talle = $request->talle;
        $compra->color = $request->color;
        $compra->fecha = $request->fecha;
        $compra->hora_inicio = $request->hora_inicio;
        $compra->hora_fin = $request->hora_fin;
        $compra->save();

        return response()->json(['message' => 'Compra agendada correctamente.']);
    }

    public function update(Request $request, $id)
    {
        // Buscar la compra en la base de datos
        $compra = CompraCalendario::find($id);

        // Verificar si se encontró la compra
        if (!$compra) {
            return response()->json(['message' => 'Compra no encontrada.'], 404);
        }

        // Actualizar los datos de la compra
        $compra->nombre_persona = $request->nombre_persona;
        $compra->articulo_id = $request->articulo_id;
        $compra->talle = $request->talle;
        $compra->color = $request->color;
        $compra->fecha = $request->fecha;
        $compra->hora_inicio = $request->hora_inicio;
        $compra->hora_fin = $request->hora_fin;

        // Guardar los cambios en la base de datos
        $compra->save();

        return response()->json(['message' => 'Compra actualizada correctamente.']);
    }

    public function destroy($id)
    {
        try {
            // Buscar la compra por id
            $compra = CompraCalendario::findOrFail($id);
            // Eliminar la compra
            $compra->delete();

            return response()->json(['message' => 'Compra eliminada correctamente.'], 200);
        } catch (ModelNotFoundException $e) {
            return response()->json(['error' => 'Compra no encontrada.'], 404);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Error al eliminar la compra.'], 500);
        }
    }



}