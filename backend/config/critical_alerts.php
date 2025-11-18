<?php

return [
    'min_stock_per_talle' => [
        'default' => 3,
        'overrides' => [
            // '38' => 4,
            // '39' => 2,
        ],
    ],
    'min_stock_per_color' => [
        // Set a default minimum for each color or leave as null to disable per-color checks
        'default' => null,
        'overrides' => [
            // 'negro' => 1,
            // 'blancobeige' => 1,
        ],
    ],
];