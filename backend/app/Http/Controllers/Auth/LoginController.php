<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Database\QueryException;
use Illuminate\Support\Facades\Log;


class LoginController extends Controller
{
    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required'],
        ]);

        try {
            if (Auth::attempt($credentials)) {
                $user = Auth::user();
                $token = $user->createToken('token-name')->plainTextToken;

                return response()->json([
                    'token' => $token,
                    'user' => $user,
                ]);
            }
        } catch (QueryException $e) {
            Log::warning('⚠️ Error de DB en login, reintentando conexión', [
                'code' => $e->getCode(),
                'message' => $e->getMessage(),
            ]);

            DB::purge();
            DB::reconnect();

            try {
                if (Auth::attempt($credentials)) {
                    $user = Auth::user();
                    $token = $user->createToken('token-name')->plainTextToken;

                    return response()->json([
                        'token' => $token,
                        'user' => $user,
                    ]);
                }
            } catch (QueryException $retryException) {
                Log::error('❌ Error de DB persistente en login', [
                    'code' => $retryException->getCode(),
                    'message' => $retryException->getMessage(),
                ]);

                return response()->json([
                    'message' => 'Servicio temporalmente no disponible. Intentá de nuevo en unos segundos.',
                ], 503);
            }
        }

        return response()->json(['message' => 'Credenciales inválidas'], 401);
    }



    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json(['message' => 'Token revocado correctamente']);
    }



    public function checkAuth(Request $request)
    {
        return response()->json([
            'authenticated' => (bool) $request->user(),
            'user' => $request->user(),
        ]);
    }


}