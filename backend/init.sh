#!/bin/bash

echo "🚀 Init start"

# # 🧬 Inyectar variables al .env manualmente
# echo "APP_ENV=$APP_ENV" > .env
# echo "APP_DEBUG=$APP_DEBUG" >> .env
# echo "APP_KEY=$APP_KEY" >> .env
# echo "APP_URL=$APP_URL" >> .env

# echo "DB_CONNECTION=$DB_CONNECTION" >> .env
# echo "DB_HOST=$DB_HOST" >> .env
# echo "DB_PORT=$DB_PORT" >> .env
# echo "DB_DATABASE=$DB_DATABASE" >> .env
# echo "DB_USERNAME=$DB_USERNAME" >> .env
# echo "DB_PASSWORD=$DB_PASSWORD" >> .env

# echo "SESSION_DRIVER=$SESSION_DRIVER" >> .env
# echo "SESSION_DOMAIN=$SESSION_DOMAIN" >> .env
# echo "SESSION_SECURE_COOKIE=$SESSION_SECURE_COOKIE" >> .env
# echo "SESSION_SAME_SITE=$SESSION_SAME_SITE" >> .env

# echo "SANCTUM_STATEFUL_DOMAINS=$SANCTUM_STATEFUL_DOMAINS" >> .env
# echo "XDG_CACHE_HOME=/tmp" >> .env # Para evitar warnings de Composer

# echo "✅ .env generado:"
# cat .env

# 🧼 Limpiar cualquier cache previa
php artisan config:clear
php artisan route:clear
php artisan view:clear

# 🔥 Generar nueva config con el .env real
php artisan config:cache

# 🕵️ Debug: Mostrar valor real cargado
php artisan tinker --execute="echo config('session.same_site');"

# 🧬 Migrar base de datos (opcional)
php artisan migrate --force

echo "✅ Init completo"
