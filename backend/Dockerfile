FROM php:8.2-fpm-alpine

# Instalar dependencias del sistema
RUN apk add --no-cache nginx curl git zip unzip mysql-client bash \
    && docker-php-ext-install pdo pdo_mysql

# Aumentar límite de memoria
RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memlimit.ini

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Establecer el directorio de trabajo
WORKDIR /var/www/html

# Copiar el código de la app
COPY . .

# Instalar dependencias de Laravel
RUN composer install --optimize-autoloader --no-dev

# Copiar nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf

# Copiar script de inicio
COPY init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 8000

CMD ["/init.sh"]

