#!/bin/bash

#Downloads WP-CLI, a command-line tool for managing WordPress installations.
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
#Makes WP-CLI executable and moves it to a global path.
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

#-------File permissions

cd /var/www/wordpress
chmod -R 755 /var/www/wordpress/
#Ensures the WordPress files are owned by the www-data user, which is the default user PHP-FPM runs as.
chown -R www-data:www-data /var/www/wordpress

#------WordPress installation
check_core_files() {
    wp core is-installed --allow-root > /dev/null
    return $?
}
#These commands download WordPress, configure it to connect to the MariaDB database, install the site with the specified settings, and create a user.
if ! check_core_files; then
    echo "[========WP INSTALLATION STARTED========]"
    find /var/www/wordpress/ -mindepth 1 -delete
    wp core download --allow-root
    wp core config --dbhost=mariadb:3306 --dbname="$MYSQL_DB" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --allow-root
    wp core install --url="$DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN_N" --admin_password="$WP_ADMIN_P" --admin_email="$WP_ADMIN_E" --allow-root
    wp user create "$WP_U_NAME" "$WP_U_EMAIL" --user_pass="$WP_U_PASS" --role="$WP_U_ROLE" --allow-root
else
    echo "[========WordPress files already exist. Skipping installation========]"
fi

# Configurate and run PHP
#Updates the PHP-FPM configuration to use port 9000 instead of a Unix socket.
sed -i '36 s@/run/php/php7.4-fpm.sock@9000@' /etc/php/7.4/fpm/pool.d/www.conf
mkdir -p /run/php

#Starts PHP-FPM in the foreground to handle PHP requests.
/usr/sbin/php-fpm7.4 -F
