FROM php:8.2-fpm-alpine

# Dependencias
RUN apk add --no-cache nginx curl git zip unzip mysql-client bash \
    && docker-php-ext-install pdo pdo_mysql

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Carpeta trabajo
WORKDIR /var/www/html

# Copiar proyecto
COPY . .

# Permisos necesarios para Laravel
RUN chown -R www-data:www-data storage bootstrap/cache && \
    chmod -R 775 storage bootstrap/cache

# Instalar dependencias de Laravel
RUN composer install --optimize-autoloader --no-dev

# Copiar config de nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Script de inicio
COPY init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 8000

CMD ["/init.sh"]
