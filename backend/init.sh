#!/bin/sh

echo "🚀 Init start"

composer dump-autoload --optimize
php artisan package:discover
php artisan config:clear

# php artisan migrate --force
php artisan serve --host=0.0.0.0 --port=8000
