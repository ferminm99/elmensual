#!/bin/sh

echo "🚀 Init start"

php artisan config:clear
php artisan config:cache
# php artisan migrate --force

# Usar el servidor embebido de PHP correctamente con index.php
php -S 0.0.0.0:${PORT:-8080} -t public

