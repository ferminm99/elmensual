#!/bin/sh

echo "🧼 Limpiando cache de Laravel"
php artisan config:clear
php artisan route:clear
php artisan view:clear

echo "⚙️ Cacheando configuración"
php artisan config:cache

echo "🚀 Iniciando Laravel"
exec php artisan serve --host=0.0.0.0 --port=8000
