<?php

namespace App\Http\Controllers;

use App\Models\Articulo;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Traits\ActualizaMetaTrait;
use App\Services\CriticalStockAlertService;
use App\Models\ConfiguracionPrecio;
use Carbon\Carbon;

class ArticuloController extends Controller
{
    use ActualizaMetaTrait;

    public function __construct(private CriticalStockAlertService $alertService)
    {
    }

     // Método para listar todos los artículos
    public function index() {
        $articulos = Articulo::with('cuotas')->orderBy('nombre')->get();// Ordena por nombre
        return response()->json($articulos);
    }
    
    // Método para crear un nuevo artículo
    public function store(Request $request) {
              $porcentajes = $this->obtenerPorcentajesConfigurados();
        $precios = $this->calcularPrecios($request->input('costo_original'), $porcentajes['efectivo'], $porcentajes['transferencia']);
        $request->validate([
            'numero' => 'required|integer|unique:articulos,numero',
            'nombre' => 'required|string|max:255',
            'precio' => 'required|numeric|min:0',
            'costo_original' => 'required|numeric|min:0',
            'cuotas' => 'nullable|array',
            'cuotas.*' => 'integer|exists:cuotas,id',
            'es_importante' => 'sometimes|boolean',
            'prioridad_alerta' => 'sometimes|integer|min:1|max:5',
        ]);

        
        $articulo = Articulo::create([
            'numero' => $request->input('numero'),
            'nombre' => $request->input('nombre'),
            'precio' => $request->input('precio'),
            'costo_original' => $request->input('costo_original'),
            'precio_efectivo' => $precios['precio_efectivo'],
            'precio_transferencia' => $precios['precio_transferencia'],
            'es_importante' => $request->boolean('es_importante'),
            'prioridad_alerta' => $request->input('prioridad_alerta', 1),
        ]);


        return response()->json([
            'message' => 'Artículo creado correctamente',
            'articulo' => $articulo
        ]);
    }

    // Método para actualizar un artículo existente
    public function update(Request $request, $id) {
        $articulo = Articulo::findOrFail($id);

        $porcentajes = $this->obtenerPorcentajesConfigurados();
        $precios = $this->calcularPrecios($request->input('costo_original'), $porcentajes['efectivo'], $porcentajes['transferencia']);
        $request->validate([
            'numero' => 'required|integer|unique:articulos,numero,' . $articulo->id,
            'nombre' => 'required|string|max:255',
            'precio' => 'required|numeric|min:0',
            'costo_original' => 'required|numeric|min:0',
            'cuotas' => 'nullable|array',
            'cuotas.*' => 'integer|exists:cuotas,id',
            'es_importante' => 'sometimes|boolean',
            'prioridad_alerta' => 'sometimes|integer|min:1|max:5',
        ]);
    
        $articulo->update([
            'numero' => $request->input('numero'),
            'nombre' => $request->input('nombre'),
            'precio' => $request->input('precio'),
            'costo_original' => $request->input('costo_original'),
            'precio_efectivo' => $precios['precio_efectivo'],
            'precio_transferencia' => $precios['precio_transferencia'],
            'es_importante' => $request->boolean('es_importante', $articulo->es_importante),
            'prioridad_alerta' => $request->input('prioridad_alerta', $articulo->prioridad_alerta),
        ]);

        $articulo->cuotas()->sync($request->input('cuotas', []));
        $articulo->load('cuotas');
        
        return response()->json([
            'message' => 'Artículo actualizado correctamente',
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

            return response()->json([
                'message' => 'Artículo eliminado exitosamente',
                'deleted_id' => $articulo->id,
                'last_update' => now()->timestamp * 1000,
            ]);
            
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
        $articulo = Articulo::with(['talles', 'cuotas'])->find($id);

        if (!$articulo) {
            return response()->json(['message' => 'Artículo no encontrado'], 404);
        }

        // Devolver el artículo con sus talles en JSON
        return response()->json($articulo);
    }

    public function listarArticulosConTalles()
    {
        $articulos = Articulo::with(['talles', 'cuotas'])->get();

        // Devolver los artículos en formato JSON
        return response()->json($articulos);
    }

    public function listarArticulos()
    {
        // Devuelve todos los artículos en formato JSON
        return response()->json(Articulo::with('cuotas')->get());
    }
    
    public function totalBombachas($id)
    {
        // Obtener el artículo y sus talles
        $articulo = Articulo::with(['talles', 'cuotas'])->find($id);

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

        $this->alertService->synchronizeForArticulo($articulo->id);

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
    
        $deletedIds = [];
    
        if (
            $talle->verde == 0 && $talle->azul == 0 && $talle->marron == 0 &&
            $talle->negro == 0 && $talle->celeste == 0 && $talle->blancobeige == 0
        ) {
            $deletedIds[] = $talle->id;
            $talle->delete();
        }

        $ultimoTalle = $articulo->talles()->latest()->first();
        if ($ultimoTalle) $ultimoTalle->touch();

        $this->alertService->synchronizeForArticulo($articulo->id);

        return response()->json([
            'message' => 'Bombachas eliminadas correctamente',
            'deleted_ids' => $deletedIds,
            'last_update' => now()->timestamp * 1000,
        ]);
    }
    
    

    public function eliminarTalleCompleto(Request $request, $id) {
        $articulo = Articulo::findOrFail($id);
        $talle = $articulo->talles()->where('talle', $request->input('talle'))->first();
    
        if ($talle) {
            $talle->delete();

            $ultimoTalle = $articulo->talles()->latest()->first();
            if ($ultimoTalle) $ultimoTalle->touch();

            $this->alertService->synchronizeForArticulo($articulo->id);

            return response()->json([
                'message' => 'Talle eliminado correctamente',
                'deleted_ids' => [$talle->id],  // aunque sea 1 id, devolvemos array
                'last_update' => now()->timestamp * 1000,
            ]);
        }

        $this->alertService->synchronizeForArticulo($articulo->id);

        return response()->json(['message' => 'Talle no encontrado'], 404);
    }



    public function editarBombachas(Request $request, $id) {
        $articulo = Articulo::findOrFail($id);
        $talleSeleccionado = $request->input('talle');
    
        // Buscar el talle y actualizar las cantidades
        $talle = $articulo->talles()->where('talle', $talleSeleccionado)->first();
    
        if ($talle) {
            $talle->update($request->input('cantidades'));
            $this->alertService->synchronizeForArticulo($articulo->id);

            return response()->json(['message' => 'Cantidades actualizadas correctamente']);
        }

        $this->alertService->synchronizeForArticulo($articulo->id);

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
 private function calcularPrecios($costo, $porcentajeEfectivo = 0, $porcentajeTransferencia = 0)
    {
        // Calcular precio base según regla
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

        // Aplicar porcentajes extra configurados sobre el valor base
        $precio_efectivo *= (1 + ((float) $porcentajeEfectivo / 100));
        $precio_transferencia *= (1 + ((float) $porcentajeTransferencia / 100));

        // Redondear con regla especial
        $precio_efectivo = $this->redondearPrecio($precio_efectivo, $costo);
        $precio_transferencia = $this->redondearPrecio($precio_transferencia, $costo);

        return [
            'precio_efectivo' => $precio_efectivo,
            'precio_transferencia' => $precio_transferencia,
        ];
    }

    private function obtenerPorcentajesConfigurados(): array
    {
        $configuracion = ConfiguracionPrecio::actual();

        return [
            'efectivo' => (float) $configuracion->porcentaje_efectivo,
            'transferencia' => (float) $configuracion->porcentaje_transferencia,
        ];
    }

    // Recalcular precios en base al costo original actual
    public function recalcularPreciosMasivamente()
    {
        $articulos = Articulo::all();
        $porcentajes = $this->obtenerPorcentajesConfigurados();

        foreach ($articulos as $articulo) {
            $precios = $this->calcularPrecios($articulo->costo_original, $porcentajes['efectivo'], $porcentajes['transferencia']);

            $articulo->update([
                'precio_efectivo' => $precios['precio_efectivo'],
                'precio_transferencia' => $precios['precio_transferencia'],
            ]);
        }

        return response()->json([
            'message' => 'Precios recalculados correctamente.',
            'articulos' => Articulo::with('cuotas')->orderBy('nombre')->get()
        ]);
    }


    public function aumentarCostoOriginal(Request $request)
    {
        $request->validate([
            'porcentaje_efectivo' => 'nullable|numeric|min:-100|max:9999',
            'porcentaje_transferencia' => 'nullable|numeric|min:-100|max:9999',
        ]);

        $configuracion = ConfiguracionPrecio::actual();
        $configuracion->update([
            'porcentaje_efectivo' => (float) $request->input('porcentaje_efectivo', $configuracion->porcentaje_efectivo),
            'porcentaje_transferencia' => (float) $request->input('porcentaje_transferencia', $configuracion->porcentaje_transferencia),
        ]);

        $articulos = Articulo::all();
        foreach ($articulos as $articulo) {
            $precios = $this->calcularPrecios(
                $articulo->costo_original,
                $configuracion->porcentaje_efectivo,
                $configuracion->porcentaje_transferencia
            );

            $articulo->update([
                'precio_efectivo' => $precios['precio_efectivo'],
                'precio_transferencia' => $precios['precio_transferencia'],
            ]);
        }

        return response()->json([
            'message' => 'Configuración de aumentos aplicada correctamente.',
            'configuracion' => [
                'porcentaje_efectivo' => (float) $configuracion->porcentaje_efectivo,
                'porcentaje_transferencia' => (float) $configuracion->porcentaje_transferencia,
            ],
            'articulos' => Articulo::with('cuotas')->orderBy('nombre')->get(),
        ]);
    }

    public function obtenerConfiguracionAumentos()
    {
        $configuracion = ConfiguracionPrecio::actual();

        return response()->json([
            'porcentaje_efectivo' => (float) $configuracion->porcentaje_efectivo,
            'porcentaje_transferencia' => (float) $configuracion->porcentaje_transferencia,
        ]);
    }



    public function ajustarCostoOriginal(Request $request)
    {
        $request->validate([
            'porcentaje' => 'required|numeric|not_in:0|min:-99.999|max:9999',
        ]);

        $porcentaje = (float) $request->input('porcentaje');
        $factor = 1 + ($porcentaje / 100);

        $articulos = Articulo::all();
        $porcentajes = $this->obtenerPorcentajesConfigurados();

        foreach ($articulos as $articulo) {
            $costoAnterior = (float) $articulo->costo_original;
            $nuevoCosto = round($costoAnterior * $factor, 2);

            $precios = $this->calcularPrecios(
                $nuevoCosto,
                $porcentajes['efectivo'],
                $porcentajes['transferencia']
            );

            $articulo->update([
                'costo_original_anterior' => $costoAnterior,
                'costo_original' => $nuevoCosto,
                'precio_efectivo' => $precios['precio_efectivo'],
                'precio_transferencia' => $precios['precio_transferencia'],
            ]);
        }

        return response()->json([
            'message' => "Costo original ajustado en {$porcentaje}%.",
            'articulos' => Articulo::with('cuotas')->orderBy('nombre')->get(),
        ]);
    }

    public function revertirAjusteCostoOriginal()
    {
        $articulos = Articulo::whereNotNull('costo_original_anterior')->get();

        if ($articulos->isEmpty()) {
            return response()->json([
                'message' => 'No hay un ajuste de costo original para revertir.',
            ], 400);
        }

        $porcentajes = $this->obtenerPorcentajesConfigurados();

        foreach ($articulos as $articulo) {
            $costoAnterior = (float) $articulo->costo_original_anterior;
            $precios = $this->calcularPrecios(
                $costoAnterior,
                $porcentajes['efectivo'],
                $porcentajes['transferencia']
            );

            $articulo->update([
                'costo_original' => $costoAnterior,
                'costo_original_anterior' => null,
                'precio_efectivo' => $precios['precio_efectivo'],
                'precio_transferencia' => $precios['precio_transferencia'],
            ]);
        }

        return response()->json([
            'message' => 'Se revirtió el último ajuste de costo original.',
            'articulos' => Articulo::with('cuotas')->orderBy('nombre')->get(),
        ]);
    }
    
    public function articulosTallesActualizadosDesde(Request $request)
    {
        $timestamp = $request->query('timestamp');

        if (!$timestamp || !is_numeric($timestamp)) {
            return response()->json(['error' => 'Timestamp inválido'], 400);
        }

        $from = now()->createFromTimestampMs($timestamp);

        $articulos = Articulo::with(['talles', 'cuotas'])
            ->where('updated_at', '>', $from)
            ->orWhereHas('talles', function ($q) use ($from) {
                $q->where('updated_at', '>', $from);
            })
            ->orWhereHas('cuotas', function ($q) use ($from) {
                $q->where('articulo_cuota.updated_at', '>', $from);
            })
            ->get();

        $lastTalleUpdate = DB::table('talles')->max('updated_at');
        $lastArticuloUpdate = DB::table('articulos')->max('updated_at');
        $lastPivotUpdate = DB::table('articulo_cuota')->max('updated_at');

        $lastUpdate = collect([$lastTalleUpdate, $lastArticuloUpdate, $lastPivotUpdate])
            ->filter()
            ->map(fn ($value) => Carbon::parse($value)->timestamp)
            ->max() ?? time();

        return response()->json([
            'data' => $articulos,
            'last_update' => $lastUpdate,
        ]);
    }


    public function articulosActualizadosDesde(Request $request)
    {
        $timestamp = $request->query('timestamp');

        if (!$timestamp || !is_numeric($timestamp)) {
            return response()->json(['message' => 'Parámetro timestamp inválido.'], 400);
        }

        $fecha = Carbon::createFromTimestamp(floor($timestamp / 1000));

        $articulos = Articulo::with('cuotas')
            ->where('updated_at', '>', $fecha)
            ->orWhereHas('cuotas', function ($query) use ($fecha) {
                $query->where('articulo_cuota.updated_at', '>', $fecha);
            })
            ->get();

        $lastArticuloUpdate = DB::table('articulos')->max('updated_at');
        $lastPivotUpdate = DB::table('articulo_cuota')->max('updated_at');

        $lastUpdate = collect([$lastArticuloUpdate, $lastPivotUpdate])
            ->filter()
            ->map(fn ($value) => Carbon::parse($value)->timestamp)
            ->max() ?? time();

        return response()->json([
            'data' => $articulos,
            'last_update' => $lastUpdate,
        ]);
    }


    public function ultimaActualizacionArticulos() {
        $lastArticulo = DB::table('articulos')->max('updated_at');
        $lastPivot = DB::table('articulo_cuota')->max('updated_at');

        $lastUpdate = collect([$lastArticulo, $lastPivot])
            ->filter()
            ->map(fn ($value) => Carbon::parse($value)->timestamp)
            ->max();

        return response()->json(['last_update' => $lastUpdate ?? time()]);
    }

    public function ultimaActualizacionTallesArticulos() {
        $lastUpdate = DB::table('talles')->max('updated_at');
        return $lastUpdate 
            ? response()->json(['last_update' => strtotime($lastUpdate)])
            : response()->json(['last_update' => time()]);
    }
    

    
}