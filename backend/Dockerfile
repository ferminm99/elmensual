# Etapa base: Usar imagen PHP FPM en Alpine
FROM php:8.2-fpm-alpine

# Instalar dependencias necesarias
RUN apk --no-cache add \
    git curl zip unzip mysql-client \
    nodejs npm \
    && docker-php-ext-install pdo pdo_mysql

# Copiar Composer desde la imagen oficial de Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Establecer directorio de trabajo
WORKDIR /var/www/html

# Copiar solo los archivos de composer para instalar dependencias sin ejecutar scripts
COPY composer.json composer.lock ./
RUN composer install --no-scripts --no-plugins --no-autoloader

# Copiar el resto del código de la aplicación
COPY . .

# Generar autoload optimizado sin ejecutar scripts adicionales
RUN composer dump-autoload --optimize --no-scripts

# Copiar init.sh y darle permisos de ejecución
COPY init.sh /init.sh
RUN chmod +x /init.sh

# (Opcional) Exponer el puerto 8000
EXPOSE 8000

# Comando de inicio: se ejecuta en tiempo de ejecución
CMD ["sh", "/init.sh"]
