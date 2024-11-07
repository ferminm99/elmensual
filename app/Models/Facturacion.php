<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Facturacion extends Model
{
    protected $table = 'facturaciones';
    protected $fillable = ['venta_id', 'fecha_facturacion'];
    public $timestamps = false; 
    
    public function venta()
    {
        return $this->belongsTo(Venta::class);
    }
}