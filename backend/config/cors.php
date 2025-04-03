<?php

return [

    'paths' => ['*'],

    'allowed_methods' => ['*'],

    'allowed_origins' => ['https://elmensual.vercel.app'],

    'allowed_origins_patterns' => [],

    'allowed_headers' => ['X-Requested-With', 'Content-Type', 'Accept', 'X-CSRF-TOKEN', '*'],

    'exposed_headers' => ['XSRF-TOKEN'],

    'max_age' => 0,

    'supports_credentials' => true,
];