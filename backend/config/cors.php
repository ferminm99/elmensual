<?php

return [
    'paths' => ['api/*', 'login', 'logout', 'csrf-token', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['https://elmensual.vercel.app','VITE_APP_URL','http://localhost:5173','APP_URL','http://localhost:8000'],
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => true,
];