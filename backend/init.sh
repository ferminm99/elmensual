#!/bin/sh

echo "🚀 Init start"

cp .env.production .env

echo "✅ .env copiado:"
cat .env

# ⚠️ Limpiar sin volver a cachear
rm -f bootstrap/cache/config.php
php artisan package:discover
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Debug del valor real (sin cache)
php artisan tinker --execute="echo config('session.same_site');"

php artisan migrate --force

php artisan serve --host=0.0.0.0 --port=8000
