<?php

namespace App\Http\Controllers;

use App\Models\CriticalStockAlert;
use App\Services\CriticalStockAlertService;
use Illuminate\Http\Request;

class CriticalStockAlertController extends Controller
{
    public function __construct(private CriticalStockAlertService $alertService)
    {
    }

    public function index(Request $request)
    {
        $sort = $request->query('sort', 'criticidad');
        $this->alertService->synchronize();
        $alerts = $this->alertService->activeAlerts($sort);

        return response()->json($alerts->map(fn (CriticalStockAlert $alert) => [
            'id' => $alert->id,
            'articulo_id' => $alert->articulo_id,
            'articulo' => [
                'id' => $alert->articulo?->id,
                'numero' => $alert->articulo?->numero,
                'nombre' => $alert->articulo?->nombre,
            ],
            'talle' => $alert->talle,
            'total_stock' => $alert->total_stock,
            'criticidad' => $alert->criticidad,
            'estado_reposicion' => $alert->estado,
            'pedido_referencia' => $alert->pedido_referencia,
            'ultimo_detectado_en' => optional($alert->ultimo_detectado_at)->toIso8601String(),
            'pedido_enlazado_en' => optional($alert->pedido_enlazado_en)->toIso8601String(),
        ]));
    }

    public function vincularPedido(Request $request, CriticalStockAlert $alert)
    {
        $request->validate([
            'pedido_referencia' => 'required|string|max:255',
        ]);

        $alert = $this->alertService->linkOrder($alert, $request->input('pedido_referencia'));

        return response()->json([
            'message' => 'Pedido vinculado correctamente',
            'alerta' => $alert,
        ]);
    }

    public function marcarResuelto(Request $request, CriticalStockAlert $alert)
    {
        $alert = $this->alertService->markResolved($alert);

        return response()->json([
            'message' => 'Alerta marcada como resuelta',
            'alerta' => $alert,
        ]);
    }
}