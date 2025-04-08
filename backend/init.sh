#!/bin/sh

echo "🚀 Init start"

# Limpiar y cachear config
php artisan config:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Iniciar servidor interno de Laravel
php artisan serve --host=0.0.0.0 --port=${PORT:-8000}
