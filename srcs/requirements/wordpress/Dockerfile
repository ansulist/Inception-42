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

# Copy the PHP-FPM configuration to the correct directory
# Adjust the version to match the installed PHP version (likely 7.4 or 8.x)

# Create directory for PHP-FPM to store its socket
RUN mkdir /run/php

# Copy the wordpress.sh file into the image
COPY ./conf/wordpress.sh /usr/local/bin/wordpress.sh

# Copy the WordPress setup script and make it executable
RUN chmod +x /usr/local/bin/wordpress.sh

# Set up the entrypoint for WordPress installation or setup tasks
ENTRYPOINT ["/usr/local/bin/wordpress.sh"]

WORKDIR /var/www/html/

#We expose the 9000 port
EXPOSE 9000

# Start PHP-FPM in the foreground
CMD ["/usr/sbin/php-fpm7.4", "-F"]
