FROM php:8.2-fpm-alpine

# Instalar dependencias
RUN apk add --no-cache nginx curl git zip unzip mysql-client bash \
    && docker-php-ext-install pdo pdo_mysql

# Aumentar límite de memoria de PHP a 512M
RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memlimit.ini

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Crear carpeta de trabajo
WORKDIR /var/www/html

# Copiar todo el proyecto
COPY . .

# Instalar dependencias de Laravel
RUN composer install --optimize-autoloader --no-dev

# Copiar configuración de nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copiar script de inicio
COPY init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 8000

CMD ["/init.sh"]
