<?php

namespace App\Http\Controllers;

use App\Models\Cliente;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Traits\ActualizaMetaTrait;

class ClienteController extends Controller
{
    use ActualizaMetaTrait;

    // Obtener todos los clientes
    public function index()
    {
        $clientes = Cliente::all(); // Recuperar todos los clientes
        return response()->json($clientes); // Devolver los clientes en formato JSON
    }

   // Crear un cliente nuevo
   public function store(Request $request)
   {
       // Crear el cliente sin validaciones adicionales
       $cliente = Cliente::create([
           'nombre' => $request->nombre,
           'apellido' => $request->apellido,
           'cuit' => $request->cuit,
           'cbu' => $request->cbu,
       ]);

       return response()->json($cliente, 201); // Devolver el cliente creado
   }

   // Actualizar un cliente existente
   public function update(Request $request, $id)
   {
       // Buscar el cliente por ID
       $cliente = Cliente::findOrFail($id);

       // Actualizar el cliente sin validaciones adicionales
       $cliente->update([
           'nombre' => $request->nombre,
           'apellido' => $request->apellido,
           'cuit' => $request->cuit,
           'cbu' => $request->cbu,
       ]);

       return response()->json($cliente); // Devolver el cliente actualizado
   }


    // Eliminar un cliente
    public function destroy($id) {
        $cliente = Cliente::findOrFail($id);
        $cliente->delete();
    
        // Tocar el updated_at del cliente más reciente (si hay otros)
        $ultimoCliente = Cliente::latest()->first();
        if ($ultimoCliente) $ultimoCliente->touch();
    
        return response()->json([
            'message' => 'Cliente eliminado exitosamente',
            'deleted_id' => $cliente->id,
            'last_update' => now()->timestamp * 1000,
        ]);
    }
    
    public function clientesActualizadosDesde(Request $request)
    {
        try {
            $timestamp = $request->query('timestamp');
            if (!$timestamp || !is_numeric($timestamp)) {
                return response()->json(['error' => 'Falta el parámetro timestamp'], 400);
            }
    
            $desde = \Carbon\Carbon::createFromTimestamp(floor($timestamp / 1000));
    
            $clientes = \App\Models\Cliente::where('updated_at', '>', $desde)->get();
            $lastUpdate = DB::table('clientes')->max('updated_at') ?? now();
    
            return response()->json([
                'data' => $clientes,
                'count' => $clientes->count(),
                'last_update' => strtotime($lastUpdate),
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Error al obtener clientes actualizados: ' . $e->getMessage(),
            ], 500);
        }
    }
    


    public function ultimaActualizacionClientes() {
        $lastUpdate = DB::table('clientes')->max('updated_at');
        return response()->json(['last_update' => strtotime($lastUpdate)]);
    }
    
    
}