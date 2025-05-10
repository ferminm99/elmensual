<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Localidad;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Traits\ActualizaMetaTrait;

class LocalidadController extends Controller
{
    use ActualizaMetaTrait;
    public function index()
    {
        try {
            return Localidad::orderByDesc('disponibilidad')->orderBy('nombre')->get();
        } catch (\Throwable $e) {
            \Log::error("Error en LocalidadController@index: " . $e->getMessage(), ['trace' => $e->getTraceAsString()]);
            return response()->json(['message' => 'Error interno en el servidor', 'error' => $e->getMessage()], 500);
        }
    }



    public function store(Request $request)
    {
        $localidad = Localidad::create($request->only(['nombre', 'disponibilidad']));
        return response()->json(['message' => 'Localidad creada', 'localidad' => $localidad]);
    }

    public function update(Request $request, $id)
    {
        $localidad = Localidad::findOrFail($id);
        $localidad->update($request->only(['nombre', 'disponibilidad']));
        return response()->json(['message' => 'Localidad actualizada', 'localidad' => $localidad]);
    }

    public function destroy($id) {
        $localidad = Localidad::findOrFail($id);
        $localidad->delete();
    
        $ultima = Localidad::latest()->first();
        if ($ultima) $ultima->touch();
    
        return response()->json([
            'message' => 'Localidad eliminada exitosamente',
            'deleted_id' => $localidad->id,
            'last_update' => now()->timestamp * 1000,
        ]);
    }
    
    
    public function localidadesActualizadasDesde(Request $request)
    {
        try {
            $timestamp = $request->query('timestamp');
            \Log::info("🕒 Timestamp recibido:", ['timestamp' => $timestamp]);

            if (!$timestamp || !is_numeric($timestamp)) {
                \Log::warning("❌ Timestamp inválido:", ['timestamp' => $timestamp]);
                return response()->json(['error' => 'Falta el parámetro timestamp'], 400);
            }

            $desde = \Carbon\Carbon::createFromTimestamp(floor($timestamp / 1000));
            \Log::info("🧮 Timestamp convertido:", ['desde' => $desde]);

            $localidades = \App\Models\Localidad::where('updated_at', '>', $desde)->get();
            $lastUpdate = DB::table('localidades')->max('updated_at') ?? now();

            \Log::info("✅ Consulta exitosa", [
                'cantidad' => $localidades->count(),
                'last_update' => $lastUpdate,
            ]);

            return response()->json([
                'data' => $localidades,
                'count' => $localidades->count(),
                'last_update' => strtotime($lastUpdate),
            ]);
        } catch (\Exception $e) {
            \Log::error("💥 Error al obtener localidades actualizadas: " . $e->getMessage(), ['trace' => $e->getTraceAsString()]);
            return response()->json([
                'error' => 'Error al obtener localidades actualizadas: ' . $e->getMessage(),
            ], 500);
        }
    }


    
    public function ultimaActualizacionLocalidades() {
        $lastUpdate = DB::table('localidades')->max('updated_at');
        return response()->json(['last_update' => strtotime($lastUpdate)]);
    }

    
}