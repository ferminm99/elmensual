#!/bin/sh

echo "🚀 Init start"

# Crear archivo .env solo si hay variables disponibles
[ -n "$APP_ENV" ] && echo "APP_ENV=$APP_ENV" > .env
[ -n "$APP_DEBUG" ] && echo "APP_DEBUG=$APP_DEBUG" >> .env
[ -n "$APP_KEY" ] && echo "APP_KEY=$APP_KEY" >> .env

[ -n "$DB_CONNECTION" ] && echo "DB_CONNECTION=$DB_CONNECTION" >> .env
[ -n "$DB_HOST" ] && echo "DB_HOST=$DB_HOST" >> .env
[ -n "$DB_PORT" ] && echo "DB_PORT=$DB_PORT" >> .env
[ -n "$DB_DATABASE" ] && echo "DB_DATABASE=$DB_DATABASE" >> .env
[ -n "$DB_USERNAME" ] && echo "DB_USERNAME=$DB_USERNAME" >> .env
[ -n "$DB_PASSWORD" ] && echo "DB_PASSWORD=$DB_PASSWORD" >> .env

[ -n "$SESSION_DRIVER" ] && echo "SESSION_DRIVER=$SESSION_DRIVER" >> .env
[ -n "$SESSION_DOMAIN" ] && echo "SESSION_DOMAIN=$SESSION_DOMAIN" >> .env
[ -n "$SESSION_SECURE_COOKIE" ] && echo "SESSION_SECURE_COOKIE=$SESSION_SECURE_COOKIE" >> .env
[ -n "$SESSION_SAME_SITE" ] && echo "SESSION_SAME_SITE=$SESSION_SAME_SITE" >> .env

[ -n "$SANCTUM_STATEFUL_DOMAINS" ] && echo "SANCTUM_STATEFUL_DOMAINS=$SANCTUM_STATEFUL_DOMAINS" >> .env

# Obligatorio para evitar problemas con Composer
echo "XDG_CACHE_HOME=/tmp" >> .env

echo "✅ .env generado:"
cat .env

php -r "file_exists('.env') && Dotenv\Dotenv::createUnsafeImmutable(__DIR__)->load();"

php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan config:cache

php artisan tinker --execute="echo config('session.same_site');"

# php artisan migrate --force

echo "✅ Init completo"

php artisan serve --host=0.0.0.0 --port=8000

