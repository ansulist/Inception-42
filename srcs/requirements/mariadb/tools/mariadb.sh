check_database_exists()
{
    if [ -d "/var/lib/mysql/$MYSQL_DATABASE" ]; 
    then
        echo "Database '$MYSQL_DATABASE' already exists."
        return 0
    else
        return 1
    fi
}

# Initialize MariaDB data directory (if not already initialized)
mysql_install_db
# Start the MariaDB service
/etc/init.d/mysql start

# Check if the database exists
if check_database_exists; 
then
    echo "No need to create the database."
else
    # Secure MySQL installation automatically (non-interactive)
    echo "Securing MariaDB installation..."
    mysql_secure_installation << _EOF_

Y                       # Answers "Yes" to the first prompt (Remove anonymous users?).
$MYSQL_ROOT_PASSWORD    # Supplies the root password for the database (this is the first time it's asked).
$MYSQL_ROOT_PASSWORD    # Repeats the root password (confirmation).
Y                       # Answers "Yes" to the next prompt (Disallow root login remotely?).
n                       # Answers "No" to the prompt about removing the test database.
Y                       # Answers "Yes" to the next prompt (Reload privilege tables now?).
Y                       # Answers "Yes" to flush the privileges, applying all changes immediately.
_EOF_                   # Marks the end of the here document.

# Grant root access from any host
    echo "Granting root access from any host..."
    echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; FLUSH PRIVILEGES;" | mysql -uroot

    # Create the WordPress database and user
    echo "Creating database '$MYSQL_DATABASE' and user '$MYSQL_USER'..."
    echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE; \
    GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; \
    FLUSH PRIVILEGES;" | mysql -uroot

    # Import WordPress database schema if the SQL file is available
    if [ -f "/usr/local/bin/wordpress.sql" ]; then
        echo "Importing WordPress database schema..."
        mysql -uroot -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /usr/local/bin/wordpress.sql
    else
        echo "WordPress SQL file not found. Skipping import."
    fi
fi

# Stop the MariaDB service (optional if not needed immediately)
/etc/init.d/mysql stop

# Execute the command passed to the script (if any)
exec "$@"