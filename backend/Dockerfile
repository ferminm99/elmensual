FROM php:8.2-cli-alpine

# Instalar dependencias necesarias
RUN apk --no-cache add bash curl git zip unzip mysql-client \
    && docker-php-ext-install pdo pdo_mysql

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Crear carpeta de trabajo
WORKDIR /var/www/html

# Copiar todo el proyecto
COPY . .

# Instalar dependencias Laravel
RUN composer install --optimize-autoloader --no-dev

# Aumentar límite de memoria
RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memlimit.ini

# Script de inicio
COPY init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 8080

CMD ["/init.sh"]
