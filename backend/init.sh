#!/bin/sh

# Limpiar y regenerar el cache de Laravel en tiempo de arranque
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan cache:clear
php artisan config:cache

# Luego arranca Laravel normalmente
php artisan serve --host=0.0.0.0 --port=8000
