<?php

namespace App\Http\Controllers;

use App\Models\Cliente;
use Illuminate\Http\Request;

class ClienteController extends Controller
{
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
    public function destroy($id)
    {
        $cliente = Cliente::findOrFail($id); // Buscar el cliente por ID
        $cliente->delete(); // Eliminar el cliente
        return response()->json(['message' => 'Cliente eliminado exitosamente']);
    }
}