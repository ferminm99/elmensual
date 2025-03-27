<?php 

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Articulo extends Model
{
    use HasFactory;
    public $timestamps = false; // Desactiva las marcas de tiempo

    protected $fillable = ['numero', 'nombre', 'precio','costo_original','precio_efectivo','precio_transferencia'];

    public function talles()
    {
        return $this->hasMany(Talle::class, 'articulo_id');
    }

    // Relación con CompraCalendario
    public function comprasCalendario()
    {
        return $this->hasMany(CompraCalendario::class, 'articulo_id');
    }
    
}