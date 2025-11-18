<?php

namespace App\Services;

use App\Models\Articulo;
use App\Models\CriticalStockAlert;
use App\Models\Talle;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Schema;

class CriticalStockAlertService
{
    private const COLOR_FIELDS = ['marron', 'negro', 'verde', 'azul', 'celeste', 'blancobeige'];

    public function synchronize(?int $articuloId = null): Collection
    {
        if (! $this->isSchemaReady()) {
            return collect();
        }

        $articles = Articulo::query()
            ->where('es_importante', true)
            ->when($articuloId, fn ($query) => $query->where('id', $articuloId))
            ->with('talles')
            ->get();

        $activeAlertIds = [];
        $now = now();

        foreach ($articles as $articulo) {
            foreach ($articulo->talles as $talle) {
                $stock = $this->stockTotal($talle);
                $talleThreshold = $this->talleThreshold($talle->talle);
                $colorThresholds = $this->colorThresholds();
                $shortage = $this->calculateShortage($talle, $talleThreshold, $colorThresholds);
                $alert = CriticalStockAlert::firstOrNew([
                    'articulo_id' => $articulo->id,
                    'talle' => $talle->talle,
                ]);

                if ($shortage > 0) {
                    $alert->criticidad = $this->calculateCriticidad($articulo, $stock, $talleThreshold, $shortage);
                    $alert->total_stock = $stock;
                    $alert->ultimo_detectado_at = $now;

                    if (! $alert->exists) {
                        $alert->estado = 'pendiente';
                    } elseif ($alert->estado === 'resuelto') {
                        $alert->estado = $alert->pedido_referencia ? 'en_reposicion' : 'pendiente';
                        $alert->resuelto_en = null;
                    }

                    if ($alert->pedido_referencia && $alert->estado === 'pendiente') {
                        $alert->estado = 'en_reposicion';
                    }

                    $alert->save();
                    $activeAlertIds[] = $alert->id;
                } else {
                    if ($alert->exists && $alert->estado !== 'resuelto') {
                        $alert->total_stock = $stock;
                        $alert->estado = 'resuelto';
                        $alert->resuelto_en = $now;
                        $alert->save();
                    }
                }
            }
        }

        CriticalStockAlert::query()
            ->when($articuloId, fn ($query) => $query->where('articulo_id', $articuloId))
            ->whereNotIn('id', $activeAlertIds)
            ->where('estado', '!=', 'resuelto')
            ->each(function (CriticalStockAlert $alert) use ($now) {
                $alert->estado = 'resuelto';
                $alert->resuelto_en = $now;
                $alert->save();
            });

        return $this->activeAlerts();
    }

    public function synchronizeForArticulo(int $articuloId): void
    {
        $this->synchronize($articuloId);
    }

    public function activeAlerts(string $sort = 'criticidad'): Collection
    {
        if (! $this->isSchemaReady()) {
            return collect();
        }

        $query = CriticalStockAlert::with('articulo')
            ->where('estado', '!=', 'resuelto');

        if ($sort === 'fecha') {
            $query->orderByDesc('ultimo_detectado_at');
        } else {
            $query->orderByDesc('criticidad')
                ->orderBy('total_stock')
                ->orderByDesc('ultimo_detectado_at');
        }

        return $query->get();
    }

    public function linkOrder(CriticalStockAlert $alert, string $pedidoReferencia): CriticalStockAlert
    {
        $alert->pedido_referencia = $pedidoReferencia;
        $alert->pedido_enlazado_en = now();
        if ($alert->estado === 'pendiente') {
            $alert->estado = 'en_reposicion';
        }
        $alert->save();

        return $alert->fresh('articulo');
    }

    public function markResolved(CriticalStockAlert $alert): CriticalStockAlert
    {
        $alert->estado = 'resuelto';
        $alert->resuelto_en = now();
        $alert->save();

        return $alert->fresh('articulo');
    }

    protected function stockTotal(Talle $talle): int
    {
        return (int) $talle->marron
            + (int) $talle->negro
            + (int) $talle->verde
            + (int) $talle->azul
            + (int) $talle->celeste
            + (int) $talle->blancobeige;
    }

     protected function talleThreshold(int $talle): int
    {
        $config = config('critical_alerts.min_stock_per_talle', []);

        $default = (int) ($config['default'] ?? 0);
        $overrides = $config['overrides'] ?? [];

        return (int) ($overrides[$talle] ?? $default);
    }

    /**
     * @return array<string, int>
     */
    protected function colorThresholds(): array
    {
        $config = config('critical_alerts.min_stock_per_color', []);

        $default = $config['default'] ?? null;
        $overrides = $config['overrides'] ?? [];

        $thresholds = [];
        foreach (self::COLOR_FIELDS as $color) {
            $value = $overrides[$color] ?? $default;
            if ($value !== null) {
                $thresholds[$color] = (int) $value;
            }
        }

        return $thresholds;
    }

    /**
     * Determine the greatest shortage considering talle and per-color thresholds.
     */
    protected function calculateShortage(Talle $talle, int $talleThreshold, array $colorThresholds): int
    {
        $stock = $this->stockTotal($talle);
        $maxShortage = max($talleThreshold - $stock, 0);

        foreach (self::COLOR_FIELDS as $color) {
            if (! array_key_exists($color, $colorThresholds)) {
                continue;
            }

            $required = $colorThresholds[$color];
            $maxShortage = max($maxShortage, $required - (int) $talle->{$color});
        }

        return $maxShortage;
    }

    protected function calculateCriticidad(Articulo $articulo, int $stock, int $talleThreshold, int $maxShortage): int
    {
        if ($stock <= 0) {
            $level = 4;
        } else {
            $halfThreshold = max(1, (int) ceil(max($talleThreshold, 1) / 2));
            if ($maxShortage >= $halfThreshold) {
                $level = 3;
            } else {
                $level = 2;
            }
        }

        return max($level, (int) $articulo->prioridad_alerta);
    }
    
    private function isSchemaReady(): bool
    {
        return Schema::hasTable('articulos')
            && Schema::hasColumn('articulos', 'es_importante')
            && Schema::hasColumn('articulos', 'prioridad_alerta')
            && Schema::hasTable('talles')
            && Schema::hasTable('critical_stock_alerts');
    }
}