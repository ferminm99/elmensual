<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ConfiguracionOfertaCantidadTramo extends Model
{
    protected $table = 'configuracion_oferta_cantidad_tramos';

    protected $fillable = [
        'min_prendas',
        'max_prendas',
        'min_costo',
        'max_costo',
        'factor_efectivo',
        'factor_transferencia',
        'orden',
        'activo',
    ];

    protected $casts = [
        'min_prendas' => 'integer',
        'max_prendas' => 'integer',
        'min_costo' => 'float',
        'max_costo' => 'float',
        'factor_efectivo' => 'float',
        'factor_transferencia' => 'float',
        'orden' => 'integer',
        'activo' => 'boolean',
    ];
}