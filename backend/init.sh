#!/bin/sh

echo "🛠️ Iniciando contenedor..."

# Reemplazar variable de entorno $PORT en nginx.conf
export PORT=${PORT:-8080}
# envsubst '$PORT' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Laravel cache
php artisan config:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Correr nginx + php-fpm
php-fpm & nginx -g "daemon off;"

