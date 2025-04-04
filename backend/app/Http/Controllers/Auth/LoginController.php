<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class LoginController extends Controller
{
    public function login(Request $request)
    {
        \Log::info('🚨 Entró al método login');

        die('Login fue ejecutado');
        $credentials = $request->only('email', 'password');

        if (Auth::attempt($credentials)) {
            $request->session()->put('logged_in', true); // opcional, para asegurar que se detecte cambio
            $request->session()->save(); // 🔥 esto es lo que nos importa

            return response()->json(['success' => true]);
        }

        return response()->json(['message' => 'Credenciales inválidas'], 401);
    }


    public function logout(Request $request)
    {
        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();
        return response()->json(['message' => 'Logout exitoso']);
    }

    public function checkAuth()
    {
        if (Auth::check()) {
            return response()->json(['authenticated' => true, 'user' => Auth::user()]);
        } else {
            return response()->json(['authenticated' => false]);
        }
    }
}