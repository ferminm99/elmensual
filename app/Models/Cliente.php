<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Cliente extends Model
{
    use HasFactory;

    // Define la tabla asociada al modelo
    protected $table = 'clientes';

    // Define los campos que se pueden llenar con mass assignment
    protected $fillable = [
        'nombre',
        'apellido',
        'cuit',
        'cbu',
    ];

    // Definir la relación con el modelo Venta (si un cliente puede tener muchas ventas)
    public function ventas()
    {
        return $this->hasMany(Venta::class);
    }
}