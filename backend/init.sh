#!/bin/sh

echo "🛠️ Iniciando contenedor..."

# Limpiar y cachear config
php artisan config:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Correr nginx y php-fpm
php-fpm & nginx -g "daemon off;"
