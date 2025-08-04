FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    php-mysql \
    php-zip \
    php-mbstring \
    php-xml \
    php-bcmath \
    unzip \
    curl \
    git \
    composer \
    && apt-get clean

# Enable Apache rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy Laravel project (from src folder)
COPY src/ /var/www/html

COPY README.md /var/www/html/README.md

# Update Apache DocumentRoot to /public
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
