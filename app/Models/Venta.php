<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Venta extends Model
{
    protected $fillable = [
        'articulo_id',
        'cliente_id',
        'talle',
        'color',
        'precio',
        'fecha',
        'forma_pago',
        'costo_original'
    ];

    public function articulo() {
        return $this->belongsTo(Articulo::class);
    }

    public function cliente() {
        return $this->belongsTo(Cliente::class);
    }
}