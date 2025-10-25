<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Cuota extends Model
{
    use HasFactory;

    protected $fillable = [
        'es_con_interes',
        'cantidad_cuotas',
        'factor_total',
    ];

    protected $casts = [
        'es_con_interes' => 'boolean',
        'factor_total' => 'float',
        'cantidad_cuotas' => 'integer',
    ];

    public function articulos()
    {
        return $this->belongsToMany(Articulo::class)->withTimestamps();
    }

    public function ventas()
    {
        return $this->hasMany(Venta::class);
    }
}