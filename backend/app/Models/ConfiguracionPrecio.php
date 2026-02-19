<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ConfiguracionPrecio extends Model
{
    protected $table = 'configuracion_precios';

    protected $fillable = [
        'porcentaje_efectivo',
        'porcentaje_transferencia',
    ];

    public static function actual(): self
    {
        return static::firstOrCreate([], [
            'porcentaje_efectivo' => 0,
            'porcentaje_transferencia' => 0,
        ]);
    }
}