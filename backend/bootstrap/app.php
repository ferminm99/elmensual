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
        $middleware->prepend(\Illuminate\Http\Middleware\VerifyCsrfToken::class);
        //$middleware->stateful(); // <- clave para sesiones cross-site
    })
    ->withExceptions(function (Exceptions $exceptions) {
        //
    })->create();