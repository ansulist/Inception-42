#!/bin/bash

check_db_exists() {
    [ -d "/var/lib/mysql/$MYSQL_DATABASE" ] && return 0 || return 1
}

# Start the MariaDB service
/etc/init.d/mysql start

# Check if database exists, if not, set up the database
if check_db_exists; then
    echo "Database exists, skipping creation."
else
    # Grant root access from any host
    echo "Granting root access from any host..."
    echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; FLUSH PRIVILEGES;" | mysql -uroot

    # Create the WordPress database and user
    echo "Creating database '$MYSQL_DATABASE' and user '$MYSQL_USER'..."
    echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE; \
          GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; \
          FLUSH PRIVILEGES;" | mysql -uroot

    # Import WordPress database schema if the SQL file is available
    [ -f "/usr/local/bin/wordpress.sql" ] && \
    mysql -uroot -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /usr/local/bin/wordpress.sql || \
    echo "No WordPress SQL file found."
fi

# Stop the MariaDB service (optional if not needed immediately)
/etc/init.d/mysql stop

# Execute the command passed to the script (if any)
exec "$@"
