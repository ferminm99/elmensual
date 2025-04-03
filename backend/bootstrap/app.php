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
        $middleware->append(\Illuminate\Session\Middleware\StartSession::class); // 🔥 clave para que funcione CSRF
        $middleware->append(\Illuminate\View\Middleware\ShareErrorsFromSession::class); // (opcional, por si usás errores)
        // $middleware->replace(
        //     \Illuminate\Foundation\Http\Middleware\VerifyCsrfToken::class,
        //     \App\Http\Middleware\VerifyCsrfToken::class
        // );
        //$middleware->prepend(\App\Http\Middleware\VerifyCsrfToken::class); // ¡En vez de replace!

    })
    ->withExceptions(function (Exceptions $exceptions) {
        //
    })->create();