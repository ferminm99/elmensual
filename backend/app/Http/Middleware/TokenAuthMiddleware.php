<?php
namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Laravel\Sanctum\PersonalAccessToken;

use Illuminate\Support\Facades\Log;

class TokenAuthMiddleware
{
    public function handle(Request $request, Closure $next)
    {
        $token = $request->bearerToken();
        // Log::info('🔐 Bearer token recibido', ['token' => $token]);

        if (!$token) {
            Log::warning('❌ Token no enviado');
            return response()->json(['message' => 'Token no enviado'], 401);
        }

        $accessToken = \Laravel\Sanctum\PersonalAccessToken::findToken($token);
        // Log::info('🧪 Token buscado', ['accessToken' => $accessToken]);

        if (!$accessToken || !$accessToken->tokenable) {
            Log::warning('❌ Token inválido o sin user');
            return response()->json(['message' => 'Token inválido'], 401);
        }

        // Log::info('✅ Usuario autenticado', ['user_id' => $accessToken->tokenable_id]);

        $request->setUserResolver(fn () => $accessToken->tokenable);

        return $next($request);
    }
}