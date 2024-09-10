<?php

namespace App\Http\Controllers;

use App\Models\Articulo;
use Illuminate\Http\Request; 

class ArticuloController extends Controller
{
     // Método para listar todos los artículos
     public function index() {
        $articulos = Articulo::all(); // Obtener todos los artículos
        return response()->json($articulos); // Devolver como JSON
    }

    // Método para crear un nuevo artículo
    public function store(Request $request) {
        $request->validate([
            'numero' => 'required|integer|unique:articulos',
            'nombre' => 'required|string|max:255',
            'precio' => 'required|numeric|min:0',
            'costo_original' => 'required|numeric|min:0',
        ]);
    
        $articulo = Articulo::create([
            'numero' => $request->input('numero'),
            'nombre' => $request->input('nombre'),
            'precio' => $request->input('precio'),
            'costo_original' => $request->input('costo_original'),
        ]);

        return response()->json([
            'message' => 'Artículo creado correctamente',
            'articulo' => $articulo
        ]);
    }

    // Método para actualizar un artículo existente
    public function update(Request $request, $id) {
        $articulo = Articulo::findOrFail($id);

        $request->validate([
            'numero' => 'required|integer|unique:articulos,numero,' . $articulo->id,
            'nombre' => 'required|string|max:255',
            'precio' => 'required|numeric|min:0',
            'costo_original' => 'required|numeric|min:0',
        ]);
    
        $articulo->update([
            'numero' => $request->input('numero'),
            'nombre' => $request->input('nombre'),
            'precio' => $request->input('precio'),
            'costo_original' => $request->input('costo_original'),
        ]);
    
        return response()->json(['message' => 'Artículo actualizado correctamente']);
    }

    // Método para eliminar un artículo
    public function destroy($id) {
        // Encontrar el artículo por ID
        $articulo = Articulo::findOrFail($id);

        // Eliminar los talles asociados al artículo
        $articulo->talles()->delete();  // Asegúrate de tener la relación definida en el modelo Articulo

        // Eliminar el artículo
        $articulo->delete();

        return response()->json(['message' => 'Artículo eliminado correctamente']);
    }
    
    public function mostrarArticulo($id)
    {
        // Obtener el artículo y sus talles
        $articulo = Articulo::with('talles')->find($id);

        if (!$articulo) {
            return response()->json(['message' => 'Artículo no encontrado'], 404);
        }

        // Devolver el artículo con sus talles en JSON
        return response()->json($articulo);
    }

    public function listarArticulosConTalles()
    {
        $articulos = Articulo::with('talles')->get();

        // Devolver los artículos en formato JSON
        return response()->json($articulos);
    }

    public function listarArticulos()
    {
        // Devuelve todos los artículos en formato JSON
        return response()->json(Articulo::all());
    }
    
    public function totalBombachas($id)
    {
        // Obtener el artículo y sus talles
        $articulo = Articulo::with('talles')->find($id);

        if (!$articulo) {
            return response()->json(['message' => 'Artículo no encontrado'], 404);
        }

        $totalBombachas = 0;

        // Sumar el total de bombachas para cada talle
        foreach ($articulo->talles as $talle) {
            $totalBombachas += $talle->totalBombachas();
        }

        // Devolver el total de bombachas en JSON
        return response()->json(['total_bombachas' => $totalBombachas]);
    }

    public function agregarBombachas(Request $request, $id) {
        $articulo = Articulo::findOrFail($id);
    
        // Obtener el talle seleccionado del request
        $talleSeleccionado = $request->input('talle');
    
        // Buscar si el talle ya existe para el artículo
        $talle = $articulo->talles()->where('talle', $talleSeleccionado)->first();
    
        // Si no existe, creamos un nuevo registro para este talle
        if (!$talle) {
            $talle = $articulo->talles()->create([
                'talle' => $talleSeleccionado,
                'verde' => 0,
                'azul' => 0,
                'marron' => 0,
                'negro' => 0,
                'celeste' => 0,
                'blancobeige' => 0,
            ]);
        }
    
        // Aplicar las cantidades enviadas en la solicitud
        foreach ($request->input('cantidades') as $color => $cantidad) {
            $talle->increment($color, $cantidad);
        }
    
        return response()->json(['message' => 'Bombachas agregadas correctamente']);
    }
    public function eliminarBombachas(Request $request, $id) {
        $articulo = Articulo::findOrFail($id);
        $talleSeleccionado = $request->input('talle');
    
        $talle = $articulo->talles()->where('talle', $talleSeleccionado)->first();
    
        if (!$talle) {
            return response()->json(['message' => 'El talle no existe'], 400);
        }
    
        foreach ($request->input('cantidades') as $color => $cantidad) {
            // Asegurarse de que no se elimine más de lo que hay disponible
            if ($talle->{$color} >= $cantidad) {
                $talle->decrement($color, $cantidad);
            } else {
                $talle->update([$color => 0]); // Si se trata de eliminar más de lo que hay, se establece en 0
            }
        }
    
        // Verificar si todos los colores del talle están en 0 para eliminar el registro
        if ($talle->verde == 0 && $talle->azul == 0 && $talle->marron == 0 && $talle->negro == 0 && $talle->celeste == 0 && $talle->blancobeige == 0) {
            $talle->delete();
        }
    
        return response()->json(['message' => 'Bombachas eliminadas correctamente']);
    }

    public function eliminarTalleCompleto(Request $request, $id) {
        $articulo = Articulo::findOrFail($id);
        $talleSeleccionado = $request->input('talle');
    
        // Buscar el talle y eliminarlo
        $talle = $articulo->talles()->where('talle', $talleSeleccionado)->first();
        if ($talle) {
            $talle->delete();
            return response()->json(['message' => 'Talle eliminado correctamente']);
        }
    
        return response()->json(['message' => 'Talle no encontrado'], 404);
    }

    public function editarBombachas(Request $request, $id) {
        $articulo = Articulo::findOrFail($id);
        $talleSeleccionado = $request->input('talle');
    
        // Buscar el talle y actualizar las cantidades
        $talle = $articulo->talles()->where('talle', $talleSeleccionado)->first();
    
        if ($talle) {
            $talle->update($request->input('cantidades'));
            return response()->json(['message' => 'Cantidades actualizadas correctamente']);
        }
    
        return response()->json(['message' => 'Talle no encontrado'], 404);
    }
    
}