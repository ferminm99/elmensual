<?php

namespace App\Http\Middleware;

use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken as Middleware;
use Symfony\Component\HttpFoundation\Cookie;

class VerifyCsrfToken extends Middleware
{
    protected function addCookieToResponse($request, $response)
    {
        \Log::info('✅ Middleware CSRF custom activo');
        // NO usar parent::addCookieToResponse
        // Laravel setea XSRF-TOKEN con HttpOnly y rompe todo

        $token = $request->session()->token();

        $response->headers->setCookie(
            Cookie::create('XSRF-TOKEN', 'TEST-' . $token, time() + 3600)
                ->withSecure(true)
                ->withSameSite('None')
                ->withHttpOnly(false)
                ->withPath('/')
                ->withDomain('.elmensual.vercel.app')
        );

        return $response;
    }
}