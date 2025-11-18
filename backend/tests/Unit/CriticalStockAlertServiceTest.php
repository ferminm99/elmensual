<?php

namespace Tests\Unit;

use App\Models\Articulo;
use App\Models\CriticalStockAlert;
use App\Services\CriticalStockAlertService;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Tests\TestCase;

class CriticalStockAlertServiceTest extends TestCase
{
    protected CriticalStockAlertService $service;

    protected function setUp(): void
    {
        parent::setUp();
        Schema::dropIfExists('critical_stock_alerts');
        Schema::dropIfExists('talles');
        Schema::dropIfExists('articulos');

        Schema::create('articulos', function (Blueprint $table) {
            $table->id();
            $table->integer('numero');
            $table->string('nombre');
            $table->decimal('precio', 10, 2);
            $table->decimal('costo_original', 10, 2);
            $table->decimal('precio_efectivo', 10, 2)->nullable();
            $table->decimal('precio_transferencia', 10, 2)->nullable();
            $table->boolean('es_importante')->default(false);
            $table->unsignedTinyInteger('prioridad_alerta')->default(1);
            $table->timestamps();
        });

        Schema::create('talles', function (Blueprint $table) {
            $table->id();
            $table->foreignId('articulo_id')->constrained('articulos');
            $table->integer('talle');
            $table->integer('marron')->default(0);
            $table->integer('negro')->default(0);
            $table->integer('verde')->default(0);
            $table->integer('azul')->default(0);
            $table->integer('celeste')->default(0);
            $table->integer('blancobeige')->default(0);
            $table->timestamps();
        });

        Schema::create('critical_stock_alerts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('articulo_id')->constrained('articulos')->cascadeOnDelete();
            $table->unsignedInteger('talle');
            $table->integer('total_stock')->default(0);
            $table->unsignedTinyInteger('criticidad')->default(1);
            $table->string('estado', 40)->default('pendiente');
            $table->string('pedido_referencia')->nullable();
            $table->timestamp('pedido_enlazado_en')->nullable();
            $table->timestamp('ultimo_detectado_at')->nullable();
            $table->timestamp('resuelto_en')->nullable();
            $table->timestamps();
            $table->unique(['articulo_id', 'talle']);
        });

        $this->service = $this->app->make(CriticalStockAlertService::class);
    }

    public function test_creates_alert_for_importante_article_without_stock(): void
    {
        $articulo = Articulo::factory()->importante(4)->create();
        $articulo->talles()->create([
            'talle' => 38,
            'marron' => 0,
            'negro' => 0,
            'verde' => 0,
            'azul' => 0,
            'celeste' => 0,
            'blancobeige' => 0,
        ]);

        $alerts = $this->service->synchronize();

        $this->assertCount(1, $alerts);
        $alert = $alerts->first();
        $this->assertSame($articulo->id, $alert->articulo_id);
        $this->assertSame(38, $alert->talle);
        $this->assertSame(4, $alert->criticidad);
        $this->assertSame('pendiente', $alert->estado);
        $this->assertNotNull($alert->ultimo_detectado_at);
    }

    public function test_resolves_alert_when_stock_returns(): void
    {
        $articulo = Articulo::factory()->importante()->create();
        $talle = $articulo->talles()->create([
            'talle' => 40,
            'marron' => 0,
            'negro' => 0,
            'verde' => 0,
            'azul' => 0,
            'celeste' => 0,
            'blancobeige' => 0,
        ]);

        $this->service->synchronize();
        $alert = CriticalStockAlert::first();
        $this->assertNotNull($alert);
        $this->assertSame('pendiente', $alert->estado);

        $talle->update(['marron' => 3]);
        $this->service->synchronizeForArticulo($articulo->id);

        $alert->refresh();
        $this->assertSame('resuelto', $alert->estado);
        $this->assertNotNull($alert->resuelto_en);
    }

    public function test_link_and_resolve_alert(): void
    {
        $articulo = Articulo::factory()->importante()->create();
        $articulo->talles()->create([
            'talle' => 42,
            'marron' => 0,
            'negro' => 0,
            'verde' => 0,
            'azul' => 0,
            'celeste' => 0,
            'blancobeige' => 0,
        ]);

        $alerts = $this->service->synchronize();
        $alert = $alerts->first();

        $linked = $this->service->linkOrder($alert, 'PED-123');
        $this->assertSame('en_reposicion', $linked->estado);
        $this->assertSame('PED-123', $linked->pedido_referencia);
        $this->assertNotNull($linked->pedido_enlazado_en);

        $resolved = $this->service->markResolved($alert->fresh());
        $this->assertSame('resuelto', $resolved->estado);
        $this->assertNotNull($resolved->resuelto_en);
    }

    public function test_returns_empty_when_schema_missing(): void
    {
        Schema::dropIfExists('critical_stock_alerts');
        Schema::dropIfExists('talles');
        Schema::dropIfExists('articulos');

        $alerts = $this->service->synchronize();

        $this->assertCount(0, $alerts);
    }
}