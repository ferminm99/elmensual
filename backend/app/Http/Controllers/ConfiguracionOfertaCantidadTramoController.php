<?php

namespace App\Http\Controllers;

use App\Models\ConfiguracionOfertaCantidadTramo;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class ConfiguracionOfertaCantidadTramoController extends Controller
{
    public function index()
    {
        return response()->json([
            'tramos' => ConfiguracionOfertaCantidadTramo::orderBy('orden')->orderBy('id')->get(),
        ]);
    }

    public function store(Request $request)
    {
        $data = $this->validar($request);

        $this->validarSuperposicion($data);

        $tramo = ConfiguracionOfertaCantidadTramo::create($data);

        return response()->json([
            'message' => 'Tramo de oferta creado correctamente.',
            'tramo' => $tramo,
            'tramos' => ConfiguracionOfertaCantidadTramo::orderBy('orden')->orderBy('id')->get(),
        ], 201);
    }

    public function update(Request $request, ConfiguracionOfertaCantidadTramo $tramo)
    {
        $data = $this->validar($request);

        $this->validarSuperposicion($data, $tramo->id);

        $tramo->update($data);

        return response()->json([
            'message' => 'Tramo de oferta actualizado correctamente.',
            'tramo' => $tramo->fresh(),
            'tramos' => ConfiguracionOfertaCantidadTramo::orderBy('orden')->orderBy('id')->get(),
        ]);
    }

    public function destroy(ConfiguracionOfertaCantidadTramo $tramo)
    {
        $tramo->delete();

        return response()->json([
            'message' => 'Tramo de oferta eliminado correctamente.',
            'tramos' => ConfiguracionOfertaCantidadTramo::orderBy('orden')->orderBy('id')->get(),
        ]);
    }

    public function seedInicial()
    {
        ConfiguracionOfertaCantidadTramo::query()->delete();

        $setInicial = [
            // 10-14
            ['min_prendas' => 10, 'max_prendas' => 14, 'min_costo' => 1, 'max_costo' => 9999, 'factor_efectivo' => 1.78, 'factor_transferencia' => 1.92],
            ['min_prendas' => 10, 'max_prendas' => 14, 'min_costo' => 10000, 'max_costo' => 15999.99, 'factor_efectivo' => 1.74, 'factor_transferencia' => 1.88],
            ['min_prendas' => 10, 'max_prendas' => 14, 'min_costo' => 16000, 'max_costo' => 24999.99, 'factor_efectivo' => 1.70, 'factor_transferencia' => 1.84],
            ['min_prendas' => 10, 'max_prendas' => 14, 'min_costo' => 25000, 'max_costo' => 29999.99, 'factor_efectivo' => 1.64, 'factor_transferencia' => 1.78],
            ['min_prendas' => 10, 'max_prendas' => 14, 'min_costo' => 30000, 'max_costo' => null, 'factor_efectivo' => 1.58, 'factor_transferencia' => 1.72],
            // 15-19
            ['min_prendas' => 15, 'max_prendas' => 19, 'min_costo' => 1, 'max_costo' => 9999, 'factor_efectivo' => 1.74, 'factor_transferencia' => 1.88],
            ['min_prendas' => 15, 'max_prendas' => 19, 'min_costo' => 10000, 'max_costo' => 15999.99, 'factor_efectivo' => 1.70, 'factor_transferencia' => 1.84],
            ['min_prendas' => 15, 'max_prendas' => 19, 'min_costo' => 16000, 'max_costo' => 24999.99, 'factor_efectivo' => 1.66, 'factor_transferencia' => 1.80],
            ['min_prendas' => 15, 'max_prendas' => 19, 'min_costo' => 25000, 'max_costo' => 29999.99, 'factor_efectivo' => 1.60, 'factor_transferencia' => 1.75],
            ['min_prendas' => 15, 'max_prendas' => 19, 'min_costo' => 30000, 'max_costo' => null, 'factor_efectivo' => 1.54, 'factor_transferencia' => 1.69],
            // 20-29
            ['min_prendas' => 20, 'max_prendas' => 29, 'min_costo' => 1, 'max_costo' => 9999, 'factor_efectivo' => 1.70, 'factor_transferencia' => 1.84],
            ['min_prendas' => 20, 'max_prendas' => 29, 'min_costo' => 10000, 'max_costo' => 15999.99, 'factor_efectivo' => 1.66, 'factor_transferencia' => 1.80],
            ['min_prendas' => 20, 'max_prendas' => 29, 'min_costo' => 16000, 'max_costo' => 24999.99, 'factor_efectivo' => 1.62, 'factor_transferencia' => 1.76],
            ['min_prendas' => 20, 'max_prendas' => 29, 'min_costo' => 25000, 'max_costo' => 29999.99, 'factor_efectivo' => 1.57, 'factor_transferencia' => 1.72],
            ['min_prendas' => 20, 'max_prendas' => 29, 'min_costo' => 30000, 'max_costo' => null, 'factor_efectivo' => 1.51, 'factor_transferencia' => 1.66],
            // 30+
            ['min_prendas' => 30, 'max_prendas' => null, 'min_costo' => 1, 'max_costo' => 9999, 'factor_efectivo' => 1.66, 'factor_transferencia' => 1.80],
            ['min_prendas' => 30, 'max_prendas' => null, 'min_costo' => 10000, 'max_costo' => 15999.99, 'factor_efectivo' => 1.62, 'factor_transferencia' => 1.76],
            ['min_prendas' => 30, 'max_prendas' => null, 'min_costo' => 16000, 'max_costo' => 24999.99, 'factor_efectivo' => 1.58, 'factor_transferencia' => 1.72],
            ['min_prendas' => 30, 'max_prendas' => null, 'min_costo' => 25000, 'max_costo' => 29999.99, 'factor_efectivo' => 1.53, 'factor_transferencia' => 1.68],
            ['min_prendas' => 30, 'max_prendas' => null, 'min_costo' => 30000, 'max_costo' => null, 'factor_efectivo' => 1.48, 'factor_transferencia' => 1.62],
        ];

        foreach ($setInicial as $index => $item) {
            ConfiguracionOfertaCantidadTramo::create([
                ...$item,
                'orden' => $index,
                'activo' => true,
            ]);
        }

        return response()->json([
            'message' => 'Set inicial de oferta +10 cargado correctamente.',
            'tramos' => ConfiguracionOfertaCantidadTramo::orderBy('orden')->orderBy('id')->get(),
        ]);
    }

    private function validar(Request $request): array
    {
        $data = $request->validate([
            'min_prendas' => ['required', 'integer', 'min:1', 'max:9999'],
            'max_prendas' => ['nullable', 'integer', 'min:1', 'max:9999'],
            'min_costo' => ['nullable', 'numeric', 'min:0'],
            'max_costo' => ['nullable', 'numeric', 'min:0'],
            'factor_efectivo' => ['required', 'numeric', 'min:0.01', 'max:9999'],
            'factor_transferencia' => ['required', 'numeric', 'min:0.01', 'max:9999'],
            'orden' => ['nullable', 'integer', 'min:0', 'max:9999'],
            'activo' => ['nullable', 'boolean'],
        ]);

        $minPrendas = (int) $data['min_prendas'];
        $maxPrendas = isset($data['max_prendas']) ? (int) $data['max_prendas'] : null;
        $minCosto = isset($data['min_costo']) ? (float) $data['min_costo'] : null;
        $maxCosto = isset($data['max_costo']) ? (float) $data['max_costo'] : null;

        if (!is_null($maxPrendas) && $minPrendas > $maxPrendas) {
            throw ValidationException::withMessages([
                'max_prendas' => 'El mínimo de prendas no puede ser mayor al máximo.',
            ]);
        }

        if (!is_null($minCosto) && !is_null($maxCosto) && $minCosto > $maxCosto) {
            throw ValidationException::withMessages([
                'max_costo' => 'El costo mínimo no puede ser mayor al máximo.',
            ]);
        }

        return [
            'min_prendas' => $minPrendas,
            'max_prendas' => $maxPrendas,
            'min_costo' => $minCosto,
            'max_costo' => $maxCosto,
            'factor_efectivo' => (float) $data['factor_efectivo'],
            'factor_transferencia' => (float) $data['factor_transferencia'],
            'orden' => (int) ($data['orden'] ?? 0),
            'activo' => (bool) ($data['activo'] ?? true),
        ];
    }

    private function validarSuperposicion(array $data, ?int $exceptId = null): void
    {
        if (!($data['activo'] ?? true)) {
            return;
        }

        $minPrendas = $data['min_prendas'];
        $maxPrendas = $data['max_prendas'];
        $minCosto = $data['min_costo'];
        $maxCosto = $data['max_costo'];

        $tramos = ConfiguracionOfertaCantidadTramo::query()
            ->when($exceptId, fn ($q) => $q->where('id', '!=', $exceptId))
            ->where('activo', true)
            ->get();

        foreach ($tramos as $tramo) {
            $intersectaPrendas = (is_null($maxPrendas) || is_null($tramo->min_prendas) || $maxPrendas >= $tramo->min_prendas)
                && (is_null($tramo->max_prendas) || is_null($minPrendas) || $tramo->max_prendas >= $minPrendas);

            if (!$intersectaPrendas) {
                continue;
            }

            $tMinCosto = is_null($tramo->min_costo) ? null : (float) $tramo->min_costo;
            $tMaxCosto = is_null($tramo->max_costo) ? null : (float) $tramo->max_costo;

            $intersectaCosto = (is_null($maxCosto) || is_null($tMinCosto) || $maxCosto >= $tMinCosto)
                && (is_null($tMaxCosto) || is_null($minCosto) || $tMaxCosto >= $minCosto);

            if ($intersectaCosto) {
                throw ValidationException::withMessages([
                    'min_costo' => 'El rango de costo se superpone con otra regla activa dentro del mismo rango de prendas.',
                ]);
            }
        }
    }
}