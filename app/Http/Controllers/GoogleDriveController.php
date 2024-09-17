<?php


namespace App\Http\Controllers;

use Google_Client;
use Google_Service_Drive;
use Illuminate\Http\Request;

class GoogleDriveController extends Controller
{
    public function redirectToGoogle()
    {
        $client = new Google_Client();
        $client->setClientId(env('GOOGLE_CLIENT_ID'));
        $client->setClientSecret(env('GOOGLE_CLIENT_SECRET'));
        $client->setRedirectUri(env('GOOGLE_REDIRECT_URI'));
        $client->addScope(Google_Service_Drive::DRIVE);

        $authUrl = $client->createAuthUrl();

        return redirect($authUrl);
    }

    public function handleGoogleCallback(Request $request)
    {
        $code = $request->get('code');
       
        
        if (!$code) {
            return redirect('/')->with('error', 'Authorization code is missing.');
        }
    
        $client = new Google_Client();
        $client->setClientId(env('GOOGLE_CLIENT_ID'));
        $client->setClientSecret(env('GOOGLE_CLIENT_SECRET'));
        $client->setRedirectUri(env('GOOGLE_REDIRECT_URI'));
    
        try {
            $client->authenticate($code);
            $token = $client->getAccessToken();
    
            // Guarda el token de acceso en sesión o base de datos
            session(['google_drive_token' => $token]);
    
            return redirect('/')->with('message', 'Google Drive linked successfully!');
        } catch (\Exception $e) {
            return redirect('/')->with('error', 'Failed to authenticate with Google: ' . $e->getMessage());
        }
    }
    

    public function uploadToDrive()
    {
        // Verificar si el token de Google Drive está presente en la sesión
        if (!session()->has('google_drive_token')) {
            return response()->json(['error' => 'Google Drive token missing.'], 401);
        }

        $client = new Google_Client();
        $client->setAccessToken(session('google_drive_token'));

        // Verificar si el token ha expirado
        if ($client->isAccessTokenExpired()) {
            // Aquí podrías manejar la lógica para refrescar el token, o simplemente regresar un error
            return response()->json(['error' => 'Access token expired.'], 401);
        }

        $service = new Google_Service_Drive($client);

        // Verificar que el archivo exista en la ruta correcta
        $filePath = storage_path('app/my_file.xlsx');
        if (!file_exists($filePath)) {
            return response()->json(['error' => 'File not found.'], 404);
        }

        // Configuración del archivo para Google Drive
        $file = new \Google_Service_Drive_DriveFile();
        $file->setName("my_uploaded_file.xlsx");

        try {
            // Sube el archivo a Google Drive
            $result = $service->files->create($file, [
                'data' => file_get_contents($filePath),
                'mimeType' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                'uploadType' => 'multipart',
            ]);

            return response()->json(['message' => 'File uploaded to Google Drive successfully!']);
        } catch (\Exception $e) {
            // Captura de errores si algo falla durante la carga
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

}