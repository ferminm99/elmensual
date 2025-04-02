<?php

namespace App\Http\Middleware;

use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken as Middleware;
use Symfony\Component\HttpFoundation\Cookie;

class VerifyCsrfToken extends Middleware
{
    protected function addCookieToResponse($request, $response)
    {
        \Log::info('✅ Middleware CSRF custom activo');

        $response = parent::addCookieToResponse($request, $response);

        $response->headers->setCookie(new Cookie(
            'XSRF-TOKEN',
            $request->session()->token(),
            time() + 60 * 60,
            '/',
            '.elmensual.vercel.app',
            true, // Secure
            false,
            false,
            'None'
        ));

        return $response;
    }
}