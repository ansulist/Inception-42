#!/bin/bash

sleep 10

# Set the working directory to /var/www/html
cd /var/www/html
	 
if [ -f ./wp-config.php ]
then
	echo "wordpress already downloaded"
else
    # Download wordpress and all config file
	# wget http://wordpress.org/latest.tar.gz
	# tar xfz latest.tar.gz
	# mv wordpress/* .
	# rm -rf latest.tar.gz
	# rm -rf wordpress

	# # Import env variables in the config file
	# sed "s/username_here/$MYSQL_USER/g" wp-config-sample.php > wp-config-sample.php
	# sed "s/password_here/$MYSQL_PASSWORD/g" wp-config-sample.php > wp-config-sample.php
	# sed "s/localhost/$MYSQL_HOSTNAME/g" wp-config-sample.php > wp-config-sample.php
	# sed "s/database_name_here/$MYSQL_DATABASE/g" wp-config-sample.php > wp-config-sample.php
	# cp wp-config-sample.php wp-config.php

    # Ensure the wp-content directory exists and set permissions
    mkdir -p /var/www/html/wp-content
    chown -R www-data:www-data /var/www/html/wp-content

	echo 'A'

	wp core download --allow-root

	echo 'B'

	wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD --dbhost=$MYSQL_HOSTNAME --allow-root  --skip-check

	echo 'C'

    wp core install --url=$DOMAIN_NAME --title=$TITLE --admin_user=$WORDPRESS_ADMIN \
        --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL \
        --allow-root

	echo 'D'

    wp user create $WORDPRESS_USER1 $WORDPRESS_USER1_EMAIL --role=author --user_pass=$WORDPRESS_USER1_PASSWORD --allow-root

 	# wp config  set WP_DEBUG true  --allow-root

    wp config set FORCE_SSL_ADMIN 'false' --allow-root

    # chmod 777 /var/www/html/wp-content

    # install theme
    # wp theme install twentyfifteen
    # wp theme activate twentyfifteen
    # wp theme update twentyfifteen
fi

/usr/sbin/php-fpm7.4 -F