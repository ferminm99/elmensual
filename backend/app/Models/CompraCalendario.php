<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CompraCalendario extends Model
{
    use HasFactory;
    public $timestamps = false; 

    protected $table = 'compras_calendario';

    protected $fillable = [
        'nombre_persona',
        'fecha',
        'descripcion',
        'hora_inicio',
        'hora_fin',
    ];

    /**
     * Relación con el modelo Articulo.
     */
    public function articulo()
    {
        return $this->belongsTo(Articulo::class, 'articulo_id');
    }
}