FROM debian:bullseye-slim

# Install PHP, PHP-FPM, and other necessary tools
RUN apt-get update && apt-get -y install \
    wget \
    curl \
    bash \
    php \
    php-mysql \
    php-fpm \
    && rm -rf /var/lib/apt/lists/*

# Download and install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Create directory for PHP-FPM to store its socket
RUN mkdir /run/php

# Ensure /var/www/html exists
RUN mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html

# Set correct ownership for the directory to avoid permission issues
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Copy the wordpress.sh file into the image and make it executable
COPY ./conf/wordpress.sh /usr/local/bin/wordpress.sh
RUN chmod +x /usr/local/bin/wordpress.sh

# Set up the entrypoint for WordPress installation or setup tasks
ENTRYPOINT ["/usr/local/bin/wordpress.sh"]

#We expose the 9000 port
# EXPOSE 9000
