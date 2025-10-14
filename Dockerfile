# Etapa base PHP-FPM
FROM php:8.3-fpm

# Instalar dependencias del sistema y extensiones PHP necesarias
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Instalar Node.js y npm (versión estable 20.x)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Instalar TailwindCSS globalmente
RUN npm install -g tailwindcss@latest postcss autoprefixer@latest

# Instalar Composer globalmente
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Crear y definir directorio de trabajo
WORKDIR /var/www

# Copiar dependencias primero para cacheo eficiente
COPY composer.json composer.lock* package.json package-lock.json* ./

# Instalar dependencias PHP y Node
RUN composer install --no-scripts --no-interaction --prefer-dist \
    && npm install

# Copiar el resto del código fuente
COPY . .

# Compilar assets de Vue + Tailwind (modo producción)
RUN npm run build

# Permisos seguros para Laravel
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Comando por defecto (PHP-FPM)
CMD ["php-fpm"]
