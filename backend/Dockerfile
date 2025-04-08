FROM php:8.2-cli-alpine

RUN apk add --no-cache git curl zip unzip mysql-client \
    && docker-php-ext-install pdo pdo_mysql

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

RUN composer install --optimize-autoloader

EXPOSE 8000

CMD php artisan serve --host=0.0.0.0 --port=${PORT:-8000}
