<?php

namespace App\Services;

use App\Models\Articulo;
use App\Models\CriticalStockAlert;
use App\Models\Talle;
use Illuminate\Support\Collection;

class CriticalStockAlertService
{
    public function synchronize(?int $articuloId = null): Collection
    {
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
                $alert = CriticalStockAlert::firstOrNew([
                    'articulo_id' => $articulo->id,
                    'talle' => $talle->talle,
                ]);

                if ($stock <= 0) {
                    $alert->criticidad = max(1, (int) $articulo->prioridad_alerta);
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
        $query = CriticalStockAlert::with('articulo')
            ->where('estado', '!=', 'resuelto');

        if ($sort === 'fecha') {
            $query->orderByDesc('ultimo_detectado_at');
        } else {
            $query->orderByDesc('criticidad')
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
}