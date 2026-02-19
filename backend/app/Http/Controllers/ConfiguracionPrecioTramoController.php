<?php

namespace App\Http\Controllers;

use App\Models\ConfiguracionPrecioTramo;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class ConfiguracionPrecioTramoController extends Controller
{
    public function index()
    {
        return response()->json([
            'tramos' => ConfiguracionPrecioTramo::orderBy('orden')->orderBy('id')->get(),
        ]);
    }

    public function store(Request $request)
    {
        $data = $this->validar($request);

        $this->validarSuperposicion($data);

        $tramo = ConfiguracionPrecioTramo::create($data);

        return response()->json([
            'message' => 'Tramo creado correctamente.',
            'tramo' => $tramo,
            'tramos' => ConfiguracionPrecioTramo::orderBy('orden')->orderBy('id')->get(),
        ], 201);
    }

    public function update(Request $request, ConfiguracionPrecioTramo $tramo)
    {
        $data = $this->validar($request);

        $this->validarSuperposicion($data, $tramo->id);

        $tramo->update($data);

        return response()->json([
            'message' => 'Tramo actualizado correctamente.',
            'tramo' => $tramo->fresh(),
            'tramos' => ConfiguracionPrecioTramo::orderBy('orden')->orderBy('id')->get(),
        ]);
    }

    public function destroy(ConfiguracionPrecioTramo $tramo)
    {
        $tramo->delete();

        return response()->json([
            'message' => 'Tramo eliminado correctamente.',
            'tramos' => ConfiguracionPrecioTramo::orderBy('orden')->orderBy('id')->get(),
        ]);
    }

    private function validar(Request $request): array
    {
        $data = $request->validate([
            'min_costo' => ['nullable', 'numeric', 'min:0'],
            'max_costo' => ['nullable', 'numeric', 'min:0'],
            'factor_efectivo' => ['required', 'numeric', 'min:0.01', 'max:9999'],
            'factor_transferencia' => ['required', 'numeric', 'min:0.01', 'max:9999'],
            'orden' => ['nullable', 'integer', 'min:0', 'max:9999'],
            'activo' => ['nullable', 'boolean'],
        ]);

        $min = isset($data['min_costo']) ? (float) $data['min_costo'] : null;
        $max = isset($data['max_costo']) ? (float) $data['max_costo'] : null;

        if (!is_null($min) && !is_null($max) && $min > $max) {
            throw ValidationException::withMessages([
                'max_costo' => 'El mínimo no puede ser mayor al máximo.',
            ]);
        }

        $data['min_costo'] = $min;
        $data['max_costo'] = $max;
        $data['factor_efectivo'] = (float) $data['factor_efectivo'];
        $data['factor_transferencia'] = (float) $data['factor_transferencia'];
        $data['orden'] = (int) ($data['orden'] ?? 0);
        $data['activo'] = (bool) ($data['activo'] ?? true);

        return $data;
    }

    private function validarSuperposicion(array $data, ?int $exceptId = null): void
    {
        if (!($data['activo'] ?? true)) {
            return;
        }

        $min = $data['min_costo'];
        $max = $data['max_costo'];

        $tramos = ConfiguracionPrecioTramo::query()
            ->when($exceptId, fn ($q) => $q->where('id', '!=', $exceptId))
            ->where('activo', true)
            ->get();

        foreach ($tramos as $tramo) {
            $tMin = is_null($tramo->min_costo) ? null : (float) $tramo->min_costo;
            $tMax = is_null($tramo->max_costo) ? null : (float) $tramo->max_costo;

            $intersecta = (is_null($max) || is_null($tMin) || $max >= $tMin)
                && (is_null($tMax) || is_null($min) || $tMax >= $min);

            if ($intersecta) {
                throw ValidationException::withMessages([
                    'min_costo' => 'El rango se superpone con otro tramo activo.',
                ]);
            }
        }
    }
}