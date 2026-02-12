<?php
namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Database\QueryException;
use Illuminate\Support\Facades\DB;

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

        try {
            $accessToken = \Laravel\Sanctum\PersonalAccessToken::findToken($token);
        } catch (QueryException $e) {
            Log::warning('⚠️ Error de DB en check-auth, reintentando conexión', [
                'code' => $e->getCode(),
                'message' => $e->getMessage(),
            ]);

            DB::purge();
            DB::reconnect();

            try {
                $accessToken = \Laravel\Sanctum\PersonalAccessToken::findToken($token);
            } catch (QueryException $retryException) {
                Log::error('❌ Error de DB persistente en check-auth', [
                    'code' => $retryException->getCode(),
                    'message' => $retryException->getMessage(),
                ]);

                return response()->json([
                    'message' => 'Servicio temporalmente no disponible. Intentá nuevamente en unos segundos.',
                ], 503);
            }
        }

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