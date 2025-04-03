<?php

namespace App\Http\Middleware;

use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken as Middleware;
use Symfony\Component\HttpFoundation\Cookie;

class VerifyCsrfToken extends Middleware
{
    protected function addCookieToResponse($request, $response)
    {
        \Log::info('✅ Middleware CSRF custom activo');

        // No llamamos a parent::addCookieToResponse
        // Porque eso pone la cookie con HttpOnly

        $response->headers->setCookie(
            Cookie::create(
                'XSRF-TOKEN',
                $request->session()->token(),
                time() + 60 * 60
            )
            ->withSecure(true)
            ->withSameSite('None')
            ->withHttpOnly(false) // 👈 clave
            ->withPath('/')
            ->withDomain('.elmensual.vercel.app')
        );

        return $response;
    }

}