FROM debian:bullseye-slim

# for debian/ubuntu based image
#update and install for the available package
# then install the mariadb server/client and vim
RUN apk update && apk add --no-cache mariadb mariadb-client
RUN apt-get install -y mariadb-server \
    mariadb-client \
    vim \
    && rm -rf /var/lib/apt/lists/*