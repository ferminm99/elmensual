<?php

return [

    'paths' => ['api/*', 'login', 'logout'],

    'allowed_methods' => ['*'],

    'allowed_origins' => ['https://elmensual.vercel.app'],

    'allowed_origins_patterns' => [],

    'allowed_headers' => ['*'],

    'exposed_headers' => [],

    'max_age' => 0,

    'supports_credentials' => true,

];