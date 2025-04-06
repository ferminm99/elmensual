#!/bin/sh

echo "🔥 Limpiando caches de Laravel"
php artisan config:clear
php artisan route:clear
php artisan view:clear

echo "🚀 Iniciando Laravel"
php artisan serve --host=0.0.0.0 --port=8000
