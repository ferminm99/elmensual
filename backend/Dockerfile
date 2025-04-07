# Base PHP
FROM php:8.2-fpm-alpine

# Instalar cosas necesarias
RUN apk --no-cache add \
    git curl zip unzip mysql-client \
    nodejs npm \
    && docker-php-ext-install pdo pdo_mysql

# Copiar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Trabajamos en /var/www/html
WORKDIR /var/www/html

# SOLO composer.json al principio
COPY composer.json composer.lock ./

# 🚫 Acá Laravel todavía no existe
RUN composer install --no-scripts --no-plugins --no-autoloader

# Ahora sí, copio Laravel
COPY . .

# Genero autoload sin ejecutar Laravel
RUN composer dump-autoload --optimize --no-scripts

# Copio init
COPY init.sh /init.sh
RUN chmod +x /init.sh

CMD ["sh", "/init.sh"]
