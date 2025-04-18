<?php

namespace App\Http\Controllers;

use App\Models\CompraCalendario;
use Illuminate\Http\Request; 
use Illuminate\Support\Facades\DB;

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
        $compra = new CompraCalendario();
        $compra->nombre_persona = $request->nombre_persona;
        $compra->fecha = $request->fecha;
        $compra->hora_inicio = $request->hora_inicio;
        $compra->hora_fin = $request->hora_fin;
        $compra->descripcion = $request->descripcion; // Guardamos la descripción
        $compra->save();

         // Retornar el objeto entero en la respuesta
        return response()->json($compra, 201);
    }

    public function update(Request $request, $id)
    {
        $compra = CompraCalendario::findOrFail($id);
        $compra->nombre_persona = $request->nombre_persona;
        $compra->fecha = $request->fecha;
        $compra->hora_inicio = $request->hora_inicio;
        $compra->hora_fin = $request->hora_fin;
        $compra->descripcion = $request->descripcion; // Actualizamos la descripción
        $compra->save();

        return response()->json($compra, 201);
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


    public function ultimaActualizacionCalendario() {
        $lastUpdate = DB::table('compras_calendario')->max('updated_at');
        return response()->json(['last_update' => strtotime($lastUpdate)]);
    }

}