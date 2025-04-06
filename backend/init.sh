#!/bin/sh

echo "🚀 Init start"

# ✅ Generar .env ANTES que cualquier otra cosa
cat <<EOF > .env
APP_ENV=$APP_ENV
APP_DEBUG=$APP_DEBUG
APP_KEY=$APP_KEY

DB_CONNECTION=$DB_CONNECTION
DB_HOST=$DB_HOST
DB_PORT=$DB_PORT
DB_DATABASE=$DB_DATABASE
DB_USERNAME=$DB_USERNAME
DB_PASSWORD=$DB_PASSWORD

SESSION_DRIVER=$SESSION_DRIVER
SESSION_DOMAIN=$SESSION_DOMAIN
SESSION_SECURE_COOKIE=$SESSION_SECURE_COOKIE
SESSION_SAME_SITE=$SESSION_SAME_SITE

SANCTUM_STATEFUL_DOMAINS=$SANCTUM_STATEFUL_DOMAINS
XDG_CACHE_HOME=/tmp
EOF

echo "✅ .env generado:"
cat .env

# ✅ Limpiar y cachear todo una vez con el .env ya presente
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan config:cache

# ✅ Mostrar valor leido desde config
php artisan tinker --execute="echo config('session.same_site');"

# 🧬 Migraciones
php artisan migrate --force

# 🚀 Mantener contenedor vivo
php artisan serve --host=0.0.0.0 --port=8000
