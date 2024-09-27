FROM debian:bullseye-slim

# Install MariaDB and necessary utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends mariadb-server mariadb-client vim && \
    rm -rf /var/lib/apt/lists/*

# Create mysqld run directory and set ownership/permissions
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 775 /var/run/mysqld

# Copy the mariadb.sh script into the container
COPY ./conf/mariadb.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/mariadb.sh

# Use mariadb.sh as the entry point to start the container
ENTRYPOINT [ "/usr/local/bin/mariadb.sh" ]

# CMD is optional if your entrypoint handles the startup
CMD ["mysqld", "--bind-address=0.0.0.0"]
