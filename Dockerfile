# Stage 1: Build the Vue app
FROM node:16-alpine as build-stage

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock) and install dependencies
COPY package*.json ./
RUN npm install

# Copy all the project files and build the Vue app
COPY . .
RUN npm run build

# Stage 2: Set up the Laravel app
FROM php:8.2-fpm as production-stage

# Set the working directory inside the container
WORKDIR /var/www

# Instalar Node.js y npm
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Copy the built Vue app files from Stage 1 to the public folder of Laravel
COPY --from=build-stage /app/public /var/www/public

# Copy the necessary Laravel resources from Stage 1
COPY --from=build-stage /app/resources /var/www/resources

# Copy Composer files to the container
COPY composer.json composer.lock /var/www/

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    default-mysql-client \
    nodejs npm 

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Set proper permissions for Laravel folders
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]
