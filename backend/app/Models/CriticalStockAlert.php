<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CriticalStockAlert extends Model
{
    use HasFactory;

    protected $fillable = [
        'articulo_id',
        'talle',
        'total_stock',
        'criticidad',
        'estado',
        'pedido_referencia',
        'pedido_enlazado_en',
        'ultimo_detectado_at',
        'resuelto_en',
    ];

    protected $casts = [
        'articulo_id' => 'integer',
        'talle' => 'integer',
        'total_stock' => 'integer',
        'criticidad' => 'integer',
        'pedido_enlazado_en' => 'datetime',
        'ultimo_detectado_at' => 'datetime',
        'resuelto_en' => 'datetime',
    ];

    public function articulo()
    {
        return $this->belongsTo(Articulo::class);
    }
}