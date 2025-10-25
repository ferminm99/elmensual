<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Venta extends Model
{
    use HasFactory;

    protected $fillable = [
        'articulo_id',
        'cliente_id',
        'talle',
        'color',
        'precio',
        'fecha',
        'forma_pago',
        'costo_original',
        'cuota_id',
        'cantidad_cuotas',
        'total_financiado',
        'importe_cuota',
    ];

    protected $casts = [
        'precio' => 'float',
        'costo_original' => 'float',
        'fecha' => 'date',
        'total_financiado' => 'float',
        'importe_cuota' => 'float',
        'cantidad_cuotas' => 'integer',
    ];

    public function articulo()
    {
        return $this->belongsTo(Articulo::class);
    }

    public function cliente()
    {
        return $this->belongsTo(Cliente::class);
    }

    public function cuota()
    {
        return $this->belongsTo(Cuota::class);
    }
}