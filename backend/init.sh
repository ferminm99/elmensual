#!/bin/sh

echo "🛠️ Iniciando contenedor..."

# Reemplazar el puerto en nginx.conf
export PORT=${PORT:-8080}
envsubst '$PORT' < /etc/nginx/nginx.conf > /etc/nginx/nginx.conf.final
mv /etc/nginx/nginx.conf.final /etc/nginx/nginx.conf

# Limpiar y cachear config
php artisan config:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Iniciar nginx y php-fpm
php-fpm & nginx -g "daemon off;"
