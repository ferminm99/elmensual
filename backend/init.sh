#!/bin/sh

echo "🚀 Init start"

cp .env.production .env

composer dump-autoload --optimize
php artisan package:discover
php artisan config:clear
php artisan config:cache

php artisan migrate --force
php artisan serve --host=0.0.0.0 --port=8000
