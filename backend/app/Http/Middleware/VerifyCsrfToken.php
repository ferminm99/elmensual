<?php

namespace App\Http\Middleware;

use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken as Middleware;
use Symfony\Component\HttpFoundation\Cookie as SymfonyCookie;

class VerifyCsrfToken extends Middleware
{
    protected function addCookieToResponse($request, $response)
    {
        
        $response = parent::addCookieToResponse($request, $response);

        $response->headers->setCookie(new SymfonyCookie(
            'XSRF-TOKEN',
            $request->session()->token(),
            time() + 60 * 60,
            '/',
            '.elmensual.vercel.app',
            true,
            false,
            false,
            'None'
        ));

        \Log::info('✅ Middleware CSRF custom activo');

        return $response;
    }
}