<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Articulo extends Model
{
    use HasFactory;
    public $timestamps = true; // Desactiva las marcas de tiempo

    protected $fillable = ['numero', 'nombre', 'precio','costo_original','precio_efectivo','precio_transferencia'];

    protected $casts = [
        'precio' => 'float',
        'costo_original' => 'float',
        'precio_efectivo' => 'float',
        'precio_transferencia' => 'float',
    ];

    public function talles()
    {
        return $this->hasMany(Talle::class, 'articulo_id');
    }

    public function cuotas()
    {
        return $this->belongsToMany(Cuota::class)->withTimestamps();
    }

    // Relación con CompraCalendario
    public function comprasCalendario()
    {
        return $this->hasMany(CompraCalendario::class, 'articulo_id');
    }

}