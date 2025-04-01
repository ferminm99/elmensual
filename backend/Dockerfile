# Etapa 1: Instalar dependencias de Composer
FROM composer:latest AS composer

# Etapa 2: Backend Laravel
FROM php:8.2-fpm-alpine

# Instalar dependencias del sistema y PHP
RUN apk --no-cache add \
    git \
    curl \
    zip \
    unzip \
    mysql-client \
    nodejs \
    npm \
    supervisor \
    && docker-php-ext-install pdo pdo_mysql

# Copiar Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Establecer directorio de trabajo
WORKDIR /var/www/html

# Copiar archivos de Laravel
COPY . .

# Instalar dependencias
RUN composer install --optimize-autoloader --no-dev && \
    chmod -R 775 storage bootstrap/cache

# Copiar configuración de supervisord
COPY supervisord.conf /etc/supervisord.conf

# Exponer el puerto para Laravel
EXPOSE 8000

# Comando para ejecutar Laravel + supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
