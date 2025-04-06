#!/bin/sh

echo "SESSION_SAME_SITE=$SESSION_SAME_SITE" > .env
echo "SESSION_SECURE_COOKIE=$SESSION_SECURE_COOKIE" >> .env
echo "SESSION_DOMAIN=$SESSION_DOMAIN" >> .env
echo "APP_ENV=$APP_ENV" >> .env
echo "APP_DEBUG=$APP_DEBUG" >> .env
echo "APP_URL=$APP_URL" >> .env
echo "DB_CONNECTION=$DB_CONNECTION" >> .env
echo "DB_HOST=$DB_HOST" >> .env
echo "DB_PORT=$DB_PORT" >> .env
echo "DB_DATABASE=$DB_DATABASE" >> .env
echo "DB_USERNAME=$DB_USERNAME" >> .env
echo "DB_PASSWORD=$DB_PASSWORD" >> .env


echo "🧼 Limpiando cache de Laravel"
php artisan config:clear
php artisan route:clear
php artisan view:clear

echo "⚙️ Cacheando configuración"
php artisan config:cache

echo "🚀 Iniciando Laravel"
exec php artisan serve --host=0.0.0.0 --port=8000
