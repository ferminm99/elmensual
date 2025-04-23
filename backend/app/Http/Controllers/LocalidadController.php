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

        if ($localidad = Localidad::latest()->first()) $localidad->touch();

        return response()->json(['message' => 'Localidad eliminada']);
    }
    
    public function ultimaActualizacionLocalidades() {
        $lastUpdate = DB::table('localidades')->max('updated_at');
        return response()->json(['last_update' => strtotime($lastUpdate)]);
    }

    
}