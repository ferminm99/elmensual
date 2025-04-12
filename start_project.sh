#!/bin/bash

# Navegar al frontend y levantar Vite
echo "Iniciando frontend..."
cd frontend
start "" npm run dev

# Navegar al backend y levantar Laravel
echo "Iniciando backend..."
cd ../backend
start "" php artisan serve --host=0.0.0.0 --port=8000

echo "Ambos servidores iniciados (Vue + Laravel)"
