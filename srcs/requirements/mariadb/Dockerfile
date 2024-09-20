FROM debian:bullseye-slim

# for debian/ubuntu based image
# update and install for the available package
# then install the mariadb server/client and vim
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y mariadb-server \
    mariadb-client \
    vim \
    && rm -rf /var/lib/apt/lists/*
# then clean up the package list to reduce the image size

# the directory where MariaDB store runtime files like the socket file and the PID(Process ID)
RUN mkdir -p /var/run/mysqld \
&& chown -R mysql:mysql /var/run/mysqld \
&& chmod 777 /var/run/mysqld
# make the directory for the mariadb
# setting proper ownership to the user and group. 
# then setting the permission to be full read, write and execute on the directory
EXPOSE 3306