#!/bin/sh

echo "🚀 Init start"

cp .env.production .env

echo "✅ .env copiado:"
cat .env

# Rehacer autoloader (opcional, por si algo cambió)
composer dump-autoload --optimize

# Descubrir paquetes con entorno ya cargado
php artisan package:discover
php artisan config:clear
php artisan route:clear
php artisan view:clear
rm -f bootstrap/cache/config.php
php artisan config:cache

# Mostrar valor real
echo "🔍 config(session.same_site):"
php artisan tinker --execute="echo config('session.same_site');"

php artisan migrate --force
php artisan serve --host=0.0.0.0 --port=8000

