FROM php:8.2-fpm-alpine

# Dependencias
RUN apk --no-cache add nginx curl git zip unzip mysql-client \
    && docker-php-ext-install pdo pdo_mysql

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Directorio de trabajo
WORKDIR /var/www/html

# Copiar composer e instalar
COPY composer.json composer.lock ./
RUN composer install --optimize-autoloader --no-dev

# Copiar todo el proyecto
COPY . .

# Copiar nginx.template y darle permisos
COPY nginx.conf.template /etc/nginx/nginx.conf.template

# Copiar y dar permisos a script de inicio
COPY init.sh /init.sh
RUN chmod +x /init.sh

# Exponer puerto (no obligatorio si usás $PORT)
EXPOSE 8080

# Ejecutar script
CMD ["/init.sh"]
