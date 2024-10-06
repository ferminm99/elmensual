# Stage 1: Build the Vue app
FROM node:20-alpine as build-stage

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy all the project files and build the Vue app
COPY . .
RUN npm run build

# Stage 2: Set up the Laravel app
FROM php:8.2-fpm-alpine as production-stage

# Set the working directory inside the container
WORKDIR /var/www

# Install system dependencies, PHP extensions, and Composer
RUN apk add --no-cache \
    git \
    curl \
    zip \
    unzip \
    mysql-client \
    oniguruma-dev && \
    docker-php-ext-install pdo_mysql mbstring pcntl bcmath && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    apk del oniguruma-dev && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# Copy the rest of the application files BEFORE running composer
COPY . /var/www

# Now run Composer install
RUN composer install --no-dev --optimize-autoloader && \
    find /var/www/storage /var/www/bootstrap/cache -type d -exec chmod 775 {} \; && \
    find /var/www/storage /var/www/bootstrap/cache -type f -exec chmod 664 {} \; && \
    chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache


# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]
