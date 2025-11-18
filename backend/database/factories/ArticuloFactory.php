<?php

namespace Database\Factories;

use App\Models\Articulo;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Articulo>
 */
class ArticuloFactory extends Factory
{
    protected $model = Articulo::class;

    public function definition(): array
    {
        return [
            'numero' => $this->faker->unique()->numberBetween(100, 999),
            'nombre' => $this->faker->words(3, true),
            'precio' => $this->faker->randomFloat(2, 100, 500),
            'costo_original' => $this->faker->randomFloat(2, 50, 200),
            'precio_efectivo' => null,
            'precio_transferencia' => null,
            'es_importante' => false,
            'prioridad_alerta' => 1,
        ];
    }

    public function importante(int $prioridad = 3): static
    {
        return $this->state(fn () => [
            'es_importante' => true,
            'prioridad_alerta' => $prioridad,
        ]);
    }
}