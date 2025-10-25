<?php

namespace App\Http\Controllers;

use App\Models\Cuota;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class CuotaController extends Controller
{
    public function index()
    {
        $cuotas = Cuota::orderBy('cantidad_cuotas')
            ->orderBy('es_con_interes')
            ->get();

        return response()->json($cuotas);
    }

    public function store(Request $request)
    {
        $data = $this->validateRequest($request);

        $cuota = Cuota::create($data);

        return response()->json([
            'message' => 'Cuota creada correctamente',
            'cuota' => $cuota,
        ], 201);
    }

    public function update(Request $request, Cuota $cuota)
    {
        $data = $this->validateRequest($request, $cuota->id);

        $cuota->update($data);

        return response()->json([
            'message' => 'Cuota actualizada correctamente',
            'cuota' => $cuota,
        ]);
    }

    public function destroy(Cuota $cuota)
    {
        $cuota->articulos()->detach();
        $cuota->delete();

        return response()->json([
            'message' => 'Cuota eliminada correctamente',
        ]);
    }

    protected function validateRequest(Request $request, ?int $ignoreId = null): array
    {
        $request->merge([
            'es_con_interes' => $request->boolean('es_con_interes'),
        ]);

        return $request->validate([
            'es_con_interes' => ['required', 'boolean'],
            'cantidad_cuotas' => [
                'required',
                'integer',
                'min:1',
                Rule::unique('cuotas')->where(function ($query) use ($request) {
                    return $query
                        ->where('es_con_interes', $request->boolean('es_con_interes'))
                        ->where('factor_total', $request->input('factor_total'));
                })->ignore($ignoreId),
            ],
            'factor_total' => ['required', 'numeric', 'min:0'],
        ]);
    }
}