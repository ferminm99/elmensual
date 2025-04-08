<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Laravel\Sanctum\PersonalAccessToken;

class LoginController extends Controller
{
    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required'],
        ]);

        if (Auth::attempt($credentials)) {
            $user = Auth::user();
            $token = $user->createToken('token-name')->plainTextToken;

            return response()->json([
                'token' => $token,
                'user' => $user,
            ]);
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
        $authHeader = $request->header('Authorization');
        $tokenString = str_replace('Bearer ', '', $authHeader);

        $token = PersonalAccessToken::findToken($tokenString);

        if ($token && $token->tokenable) {
            return response()->json([
                'authenticated' => true,
                'user' => $token->tokenable,
            ]);
        }

        return response()->json(['authenticated' => false]);
    }




}