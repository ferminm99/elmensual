FROM php:8.2-fpm-alpine

# Instalar dependencias necesarias
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

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working dir
WORKDIR /var/www/html

# Copiar todo el código + init.sh
COPY . .
COPY init.sh /init.sh
RUN chmod +x /init.sh

# NO HAGAS config:cache acá
RUN composer install --optimize-autoloader --no-dev --no-scripts

CMD ["sh", "/init.sh"]
