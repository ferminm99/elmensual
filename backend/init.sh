#!/bin/sh

echo "🚀 Init start"

# 🧬 Copiar el .env preparado para producción
cp .env.production .env

echo "✅ .env copiado:"
cat .env

# 🧼 Limpiar cualquier cache previa
php artisan config:clear
php artisan route:clear
php artisan view:clear

# ⚙️ Generar nueva cache con entorno limpio
php artisan config:cache

# 🧪 Mostrar valor real cargado
php artisan tinker --execute="echo config('session.same_site');"

# # 🧬 (opcional) Migrar base de datos
# php artisan migrate --force

echo "✅ Init completo"

# 🚀 Levantar el servidor para Railway
php artisan serve --host=0.0.0.0 --port=8000
