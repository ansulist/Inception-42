FROM debian:bullseye-slim

# Install MariaDB and necessary utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends mariadb-server mariadb-client vim && \
    rm -rf /var/lib/apt/lists/*

# Create mysqld run directory and set ownership/permissions
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 775 /var/run/mysqld

# RUN sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
# Copy the mariadb.sh script into the container
COPY ./conf/mariadb.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/mariadb.sh

# Copy the wordpress.sql file into the container
# COPY ../wordpress/conf/wordpress.sql /usr/local/bin/wordpress.sql

# Setup everything and run the mariadb server
ENTRYPOINT [ "/usr/local/bin/mariadb.sh" ]