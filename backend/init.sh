#!/bin/sh

echo "🔥 Limpiando caches de Laravel"
php artisan config:clear
php artisan route:clear
php artisan view:clear

echo "⚙️ Cacheando config (usa .env ya cargado)"
php artisan config:cache

echo "🚀 Iniciando Laravel"
php artisan serve --host=0.0.0.0 --port=8000
