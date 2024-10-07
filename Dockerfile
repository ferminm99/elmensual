# Usar PHP 8.2 con Alpine como base
FROM php:8.2-fpm-alpine

# Instalar dependencias del sistema, PHP y supervisord
RUN apk --no-cache add \
    git \
    curl \
    zip \
    unzip \
    nodejs \
    npm \
    mysql-client \
    supervisor \
    && docker-php-ext-install pdo pdo_mysql \
    && rm -rf /var/cache/apk/*

# Instalar Composer directamente desde la imagen de Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Establecer el directorio de trabajo en el contenedor
WORKDIR /var/www/html

# Copiar los archivos composer.json y package.json antes para aprovechar la cache
COPY composer.json composer.lock ./ 
COPY package.json package-lock.json ./ 

# Instalar dependencias de Composer y Node.js en una sola capa
RUN composer install --prefer-dist --no-scripts --no-autoloader \
    && npm install

# Copiar el resto del proyecto
COPY . .

# Construir los assets de Vue.js
RUN npm run build \
    && composer dump-autoload --optimize \
    && rm -rf /root/.npm /tmp/* /var/cache/apk/*

# Establecer permisos para los directorios necesarios
RUN chmod -R 775 storage bootstrap/cache

# Copiar la configuración de supervisord
COPY supervisord.conf /etc/supervisord.conf

# Exponer el puerto 8000 para Laravel
EXPOSE 8000

# Comando por defecto para iniciar supervisord y gestionar Laravel y npm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
