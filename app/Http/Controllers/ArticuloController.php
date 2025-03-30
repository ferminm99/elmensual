<?php

namespace App\Http\Controllers;

use App\Models\Articulo;
use Illuminate\Http\Request; 

class ArticuloController extends Controller
{
     // Método para listar todos los artículos
    public function index() {
        $articulos = Articulo::orderBy('nombre')->get(); // Ordena por nombre
        return response()->json($articulos);
    }
    
    // Método para crear un nuevo artículo
    public function store(Request $request) {

        $precios = $this->calcularPrecios($request->input('costo_original'));

        $articulo = Articulo::create([
            'numero' => $request->input('numero'),
            'nombre' => $request->input('nombre'),
            'precio' => $request->input('precio'),
            'costo_original' => $request->input('costo_original'),
            'precio_efectivo' => $precios['precio_efectivo'],
            'precio_transferencia' => $precios['precio_transferencia'],
        ]);


        return response()->json([
            'message' => 'Artículo creado correctamente',
            'articulo' => $articulo
        ]);
    }

    // Método para actualizar un artículo existente
    public function update(Request $request, $id) {
        $articulo = Articulo::findOrFail($id);

        $precios = $this->calcularPrecios($request->input('costo_original'));

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
            'precio_efectivo' => $precios['precio_efectivo'],
            'precio_transferencia' => $precios['precio_transferencia'],
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

    private function redondearPrecio($valor, $costo)
    {
        // if ($costo >= 16500 && $costo <= 17500) {
        //     // Redondear al múltiplo de 500 más cercano
        //     return round($valor / 500) * 500;
        // } else {
        //     // Redondear al múltiplo de 1000 más cercano
        //     return round($valor / 1000) * 1000;
        // }
        return round($valor / 500) * 500;
    }

    private function calcularPrecios($costo)
    {
        // Calcular precio efectivo según regla
        if ($costo >= 25000) {
            $precio_efectivo = $costo * 1.75;
        } elseif ($costo < 15750) {
            $precio_efectivo = $costo * 1.8;
        } else {
            $precio_efectivo = $costo * 1.75;
        }

        // Transferencia = efectivo * 1.1
        $precio_transferencia = $precio_efectivo * 1.1;

        // Redondear con regla especial
        $precio_efectivo = $this->redondearPrecio($precio_efectivo, $costo);
        $precio_transferencia = $this->redondearPrecio($precio_transferencia, $costo);

        return [
            'precio_efectivo' => $precio_efectivo,
            'precio_transferencia' => $precio_transferencia
        ];
    }

    
    // Recalcular precios en base al costo original actual
    public function recalcularPreciosMasivamente()
    {
        $articulos = Articulo::all();

        foreach ($articulos as $articulo) {
            $precios = $this->calcularPrecios($articulo->costo_original);

            $articulo->update([
                'precio_efectivo' => $precios['precio_efectivo'],
                'precio_transferencia' => $precios['precio_transferencia'],
            ]);
        }

        return response()->json(['message' => 'Precios recalculados correctamente.']);
    }

    // Aumentar todos los costos originales por porcentaje
    public function aumentarCostoOriginal(Request $request)
    {
        $porcentaje = $request->input('porcentaje');

        if (!$porcentaje || !is_numeric($porcentaje)) {
            return response()->json(['message' => 'Porcentaje inválido.'], 400);
        }

        $articulos = Articulo::all();

        foreach ($articulos as $articulo) {
            $nuevoCosto = $articulo->costo_original * (1 + $porcentaje / 100);
            $precios = $this->calcularPrecios($nuevoCosto);

            $articulo->update([
                'costo_original' => $nuevoCosto,
                'precio_efectivo' => $precios['precio_efectivo'],
                'precio_transferencia' => $precios['precio_transferencia'],
            ]);
        }

        return response()->json(['message' => "Costos y precios actualizados con un incremento del $porcentaje%."]);
    }


    
}