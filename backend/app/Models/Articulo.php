<?php 

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\CriticalStockAlert;
use App\Models\Cuota;

class Articulo extends Model
{
    use HasFactory;
    public $timestamps = true; // Desactiva las marcas de tiempo

    protected $fillable = [
        'numero',
        'nombre',
        'precio',
        'costo_original',
        'costo_original_anterior',
        'precio_efectivo',
        'precio_transferencia',
        'es_importante',
        'prioridad_alerta',
    ];

    protected $casts = [
        'es_importante' => 'boolean',
        'prioridad_alerta' => 'integer',
    ];

    public function talles()
    {
        return $this->hasMany(Talle::class, 'articulo_id');
    }

    public function criticalAlerts()
    {
        return $this->hasMany(CriticalStockAlert::class, 'articulo_id');
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