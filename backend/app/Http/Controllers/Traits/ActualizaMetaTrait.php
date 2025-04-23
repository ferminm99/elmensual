<?
// app/Http/Controllers/Traits/ActualizaMetaTrait.php
namespace App\Http\Controllers\Traits;

use Illuminate\Support\Facades\DB;

trait ActualizaMetaTrait {
    public function actualizarMeta($clave) {
        DB::table('meta_updates')->updateOrInsert(
            ['clave' => $clave],
            ['last_update' => time()]
        );
    }

    public function obtenerMeta($clave)
    {
        return DB::table('meta_updates')->where('clave', $clave)->value('updated_at');
    }
    
}