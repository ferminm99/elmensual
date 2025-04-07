FROM php:8.2-fpm-alpine

RUN apk --no-cache add \
    git \
    curl \
    zip \
    unzip \
    mysql-client \
    supervisor \
    nodejs \
    npm \
    && docker-php-ext-install pdo pdo_mysql

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copiamos solo composer.json para instalar dependencias sin tocar Laravel todavía
COPY composer.json composer.lock ./
RUN composer install --no-scripts --no-autoloader

# Ahora sí copiamos todo el código
COPY . .

# Generamos el autoloader SIN ejecutar Laravel
RUN composer dump-autoload --optimize --no-scripts

# Copiamos el init.sh
COPY init.sh /init.sh
RUN chmod +x /init.sh

CMD ["sh", "/init.sh"]
