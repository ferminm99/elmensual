<?php

namespace Database\Factories;

use App\Models\Articulo;
use App\Models\Talle;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Talle>
 */
class TalleFactory extends Factory
{
    protected $model = Talle::class;

    public function definition(): array
    {
        return [
            'articulo_id' => Articulo::factory(),
            'talle' => $this->faker->numberBetween(30, 60),
            'marron' => 0,
            'negro' => 0,
            'verde' => 0,
            'azul' => 0,
            'celeste' => 0,
            'blancobeige' => 0,
        ];
    }

    public function conStock(int $cantidad = 5): static
    {
        return $this->state(fn () => [
            'marron' => $cantidad,
        ]);
    }
}