FROM php:8.2-fpm-alpine

RUN apk --no-cache add nginx curl git zip unzip mysql-client \
    && docker-php-ext-install pdo pdo_mysql

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

# Instalar dependencias de Laravel
RUN composer install --optimize-autoloader --no-dev

# Copiar nginx.conf y darle permisos
RUN cp /etc/nginx/nginx.conf.template /etc/nginx/nginx.conf

# Copiar y dar permisos a script de inicio
COPY init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 80

CMD ["/init.sh"]
