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
        \Log::info('🧪 Session ID actual: ' . $request->session()->getId());
        \Log::info('🧪 CSRF token recibido: ' . $request->header('X-XSRF-TOKEN'));

        $credentials = $request->only('email', 'password');

        if (Auth::attempt($credentials)) {
            // ✅ NO regeneres la sesión acá manualmente si usás Sanctum y frontend separado
            // Laravel ya maneja esto y regenerar puede romper el flujo si no se maneja bien

            // Opcional: podés guardar algo en sesión si querés
            $request->session()->put('logged_in', true);

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