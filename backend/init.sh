#!/bin/sh

echo "🚀 Init start"

# composer dump-autoload --optimize

# ⚠️ Sobrescribir la config de sesión directamente
# echo "<?php return ['same_site' => 'none'];" > config/session.php

# Reinstalar sin scripts ni cache anticipada
# composer install --no-scripts --no-autoloader
# composer dump-autoload --optimize

# Limpiar config
php artisan config:clear
# php artisan config:cache

# Verificar que se tomó correctamente
php artisan tinker --execute="echo '🧪 same_site: ' . config('session.same_site');"

# php artisan migrate --force
php artisan serve --host=0.0.0.0 --port=8000
