<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Localidad;

class LocalidadController extends Controller
{
    public function index()
    {
        return Localidad::orderByDesc('disponibilidad')->orderBy('nombre')->get();
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
        return response()->json(['message' => 'Localidad actualizada']);
    }

    public function destroy($id)
    {
        $localidad = Localidad::findOrFail($id);
        $localidad->delete();
        return response()->json(['message' => 'Localidad eliminada']);
    }
}