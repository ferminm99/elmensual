<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ConfiguracionPrecioTramo extends Model
{
    protected $table = 'configuracion_precio_tramos';

    protected $fillable = [
        'min_costo',
        'max_costo',
        'factor_efectivo',
        'factor_transferencia',
        'orden',
        'activo',
    ];

    protected $casts = [
        'min_costo' => 'float',
        'max_costo' => 'float',
        'factor_efectivo' => 'float',
        'factor_transferencia' => 'float',
        'orden' => 'integer',
        'activo' => 'boolean',
    ];
}