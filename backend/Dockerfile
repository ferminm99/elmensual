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

# Copiar solo composer.json y composer.lock
COPY composer.json composer.lock ./

# Instalar dependencias sin ejecutar NADA
RUN COMPOSER_ALLOW_SUPERUSER=1 COMPOSER_DISABLE_XDEBUG_WARN=1 composer install --no-scripts --no-plugins --no-autoloader

# Ahora sí copiamos todo el código (después de instalar)
COPY . .

# Generar autoloader SIN ejecutar Laravel
RUN composer dump-autoload --optimize --no-scripts

# Copiar el script init
COPY init.sh /init.sh
RUN chmod +x /init.sh

CMD ["sh", "/init.sh"]
