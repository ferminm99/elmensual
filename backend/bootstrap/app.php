<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
        $middleware->prepend(\Illuminate\Http\Middleware\HandleCors::class);
        // 🔥 Forzar uso de tu propia clase CSRF
        $middleware->alias('csrf', \App\Http\Middleware\VerifyCsrfToken::class);
        $middleware->stateful(); // <- clave para sesiones cross-site
    })
    ->withSession(function () {
        return [
            'driver' => 'file',
            'lifetime' => 120,
            'expire_on_close' => false,
            'encrypt' => false,
            'files' => storage_path('framework/sessions'),
            'connection' => null,
            'table' => 'sessions',
            'store' => null,
            'lottery' => [2, 100],
            'cookie' => 'elmensual_session',
            'path' => '/',
            'domain' => '.elmensual.vercel.app',
            'secure' => true,
            'http_only' => true,
            'same_site' => 'none',
        ];
    })
    ->withExceptions(function (Exceptions $exceptions) {
        //
    })->create();