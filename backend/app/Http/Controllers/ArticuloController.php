<?php

namespace App\Http\Controllers;

use App\Models\Articulo;
use Illuminate\Http\Request; 
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Traits\ActualizaMetaTrait;

class ArticuloController extends Controller
{
    use ActualizaMetaTrait;
     // Método para listar todos los artículos
    public function index() {
        $articulos = Articulo::orderBy('nombre')->get(); // Ordena por nombre
        return response()->json($articulos);
    }
    
    // Método para crear un nuevo artículo
    public function store(Request $request) {

        $precios = $this->calcularPrecios($request->input('costo_original'));

        $request->validate([
            'numero' => 'required|integer|unique:articulos,numero',
            'nombre' => 'required|string|max:255',
            'precio' => 'required|numeric|min:0',
            'costo_original' => 'required|numeric|min:0',
        ]);

        
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
    
        return response()->json([
            'message' => 'Artículo creado correctamente',
            'articulo' => $articulo
        ]);
    }

    // Método para eliminar un artículo
    public function destroy($id)
    {
        try {
            $articulo = Articulo::find($id);

            if (!$articulo) {
                return response()->json([
                    'message' => 'El artículo ya no existe o fue eliminado.',
                ], 404);
            }

            $articulo->talles()->delete();
            $articulo->delete();

            if ($ultimo = Articulo::latest()->first()) $ultimo->touch();
            if ($ultimoTalle = \App\Models\Talle::latest()->first()) $ultimoTalle->touch();

            return response()->json(['message' => 'Artículo eliminado correctamente']);
        } catch (\Exception $e) {
            \Log::error("❌ Error al eliminar artículo {$id}: " . $e->getMessage());
            return response()->json([
                'message' => 'Error al eliminar el artículo',
                'error' => $e->getMessage(),
            ], 500);
        }
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
        $talle = $articulo->talles()->where('talle', $request->input('talle'))->first();
    
        if (!$talle) return response()->json(['message' => 'El talle no existe'], 400);
    
        foreach ($request->input('cantidades') as $color => $cantidad) {
            if ($talle->{$color} >= $cantidad) {
                $talle->decrement($color, $cantidad);
            } else {
                $talle->update([$color => 0]);
            }
        }
    
        if (
            $talle->verde == 0 && $talle->azul == 0 && $talle->marron == 0 &&
            $talle->negro == 0 && $talle->celeste == 0 && $talle->blancobeige == 0
        ) {
            $talle->delete();
        }
    
        $ultimoTalle = $articulo->talles()->latest()->first();
        if ($ultimoTalle) $ultimoTalle->touch();
    
        return response()->json(['message' => 'Bombachas eliminadas correctamente']);
    }
    

    public function eliminarTalleCompleto(Request $request, $id) {
        $articulo = Articulo::findOrFail($id);
        $talle = $articulo->talles()->where('talle', $request->input('talle'))->first();
    
        if ($talle) {
            $talle->delete();
    
            $ultimoTalle = $articulo->talles()->latest()->first();
            if ($ultimoTalle) $ultimoTalle->touch();
    
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
            $precio_efectivo = $costo * 1.74;
            $precio_transferencia = $costo * 1.89;
        } elseif ($costo < 15750) {
            $precio_efectivo = $costo * 1.8;
            $precio_transferencia = $costo * 1.95;
        } else {
            $precio_efectivo = $costo * 1.74;
            $precio_transferencia = $costo * 1.89;
        }

        // Transferencia = efectivo * 1.1
        // $precio_transferencia = $precio_efectivo * 1.1;

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

        return response()->json([
            'message' => 'Precios recalculados correctamente.',
            'articulos' => Articulo::orderBy('nombre')->get()
        ]);
    }


    public function aumentarCostoOriginal(Request $request)
    {
        $porcentaje = $request->input('porcentaje');

        if (!$porcentaje || !is_numeric($porcentaje)) {
            return response()->json(['message' => 'Porcentaje inválido.'], 400);
        }

        $articulos = Articulo::all();

        foreach ($articulos as $articulo) {
            // Calcular nuevo costo con porcentaje
            $nuevoCosto = $articulo->costo_original * (1 + $porcentaje / 100);

            // Redondear a múltiplo más cercano de 5 (entero, sin coma)
            $nuevoCosto = round($nuevoCosto / 5) * 5;

            // Calcular nuevos precios
            $precios = $this->calcularPrecios($nuevoCosto);

            $articulo->update([
                'costo_original' => $nuevoCosto,
                'precio_efectivo' => $precios['precio_efectivo'],
                'precio_transferencia' => $precios['precio_transferencia'],
            ]);
        }

        return response()->json([
            'message' => "Costos y precios actualizados con un incremento del $porcentaje%.",
            'articulos' => Articulo::orderBy('nombre')->get()
        ]);
    }



    public function articulosTallesActualizadosDesde(Request $request)
    {
        $timestamp = $request->query('timestamp');

        if (!$timestamp || !is_numeric($timestamp)) {
            return response()->json(['error' => 'Timestamp inválido'], 400);
        }

        $from = now()->createFromTimestampMs($timestamp);

        $articulos = Articulo::with('talles')
            ->where('updated_at', '>', $from)
            ->orWhereHas('talles', function ($q) use ($from) {
                $q->where('updated_at', '>', $from);
            })
            ->get();

        $lastUpdate = DB::table('talles')->max('updated_at') ?? now();

        return response()->json([
            'data' => $articulos,
            'last_update' => strtotime($lastUpdate),
        ]);
    }


    public function articulosActualizadosDesde(Request $request)
    {
        $timestamp = $request->query('timestamp');

        if (!$timestamp || !is_numeric($timestamp)) {
            return response()->json(['message' => 'Parámetro timestamp inválido.'], 400);
        }

        $fecha = \Carbon\Carbon::createFromTimestamp(floor($timestamp / 1000));

        $articulos = Articulo::where('updated_at', '>', $fecha)->get();

        $lastUpdate = DB::table('articulos')->max('updated_at') ?? now();

        return response()->json([
            'data' => $articulos,
            'last_update' => strtotime($lastUpdate),
        ]);
    }


    public function ultimaActualizacionArticulos() {
        $lastUpdate = DB::table('articulos')->max('updated_at');
        return response()->json(['last_update' => strtotime($lastUpdate)]);
    }

    public function ultimaActualizacionTallesArticulos() {
        $lastUpdate = DB::table('talles')->max('updated_at');
        return $lastUpdate 
            ? response()->json(['last_update' => strtotime($lastUpdate)])
            : response()->json(['last_update' => time()]);
    }
    

    
}