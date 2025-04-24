<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Talle extends Model
{
    use HasFactory;
    public $timestamps = true; // Desactiva las marcas de tiempo

    protected $fillable = ['articulo_id', 'talle', 'marron', 'negro', 'verde', 'azul', 'celeste', 'blancobeige'];

    public function articulo()
    {
        return $this->belongsTo(Articulo::class, 'articulo_id');
    }

    // Método para obtener el total de bombachas en un talle
    public function totalBombachas()
    {
        return $this->marron + $this->negro + $this->verde + $this->azul + $this->celeste + $this->blancobeige;
    }
}