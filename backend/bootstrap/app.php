<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php', // 👈🏽 esta línea es la clave
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
        $middleware->prepend(\Illuminate\Http\Middleware\HandleCors::class);
        // $middleware->append(\Illuminate\Session\Middleware\StartSession::class);
        // $middleware->append(\Illuminate\View\Middleware\ShareErrorsFromSession::class);
        // $middleware->append(\Laravel\Sanctum\Http\Middleware\EnsureFrontendRequestsAreStateful::class); 
        // $middleware->append(\Illuminate\Foundation\Http\Middleware\VerifyCsrfToken::class); 
        // $middleware->validateCsrfTokens(except: [
        //     'api/login',  // <--- O la ruta que quieras deshabilitar
        //     'api/'
        // ]);
        // //
    })
    ->withExceptions(function (Exceptions $exceptions) {
        //
    })->create();