#!/bin/bash

# Start the MariaDB server using mysqld_safe in the background
mysqld_safe --datadir='/var/lib/mysql' &

# Wait for MariaDB to be ready before proceeding
while ! mysqladmin ping --silent; do
    sleep 1
done

# Check if the WordPress database already exists
DB_EXISTS=$(echo "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '$MYSQL_DATABASE';" | mysql -uroot -s -N)

if [ "$DB_EXISTS" == "$MYSQL_DATABASE" ]; then
    echo "Database '$MYSQL_DATABASE' already exists, skipping creation."
else
    # Grant root access from any host
    echo "Granting root access from any host..."
    echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; FLUSH PRIVILEGES;" | mysql -uroot

    # Create the WordPress database and user
    echo "Creating database '$MYSQL_DATABASE' and user '$MYSQL_USER'..."
    echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE; \
            GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; \
            FLUSH PRIVILEGES;" | mysql -uroot
fi

# Import WordPress database schema if the SQL file is available
# [ -f "/usr/local/bin/wordpress.sql" ] && \
# mysql -uroot -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /usr/local/bin/wordpress.sql || \
# echo "No WordPress SQL file found."

# Keep the container running by running mysqld_safe in the foreground
wait