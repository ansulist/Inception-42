FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y

#web server, generate SSL certificates, and other utilities
RUN apt-get install -y nginx openssl vim zsh wget git

#directory to store the SSL certificate
RUN mkdir -p /etc/nginx/ssl

#making sure that the certificate is self signed in the X.509 format
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout \
    /etc/nginx/ssl/inception.key -subj "/C=ID/ST=ID/L=TG/O=42AD/OU=42AD/CN=ansulist.42.fr/UID=ansulist"

#Copies the custom NGINX configuration file that defines how NGINX interacts with WordPress
COPY conf/nginx.conf /etc/nginx/nginx.conf

COPY tools/auto.sh /auto.sh

RUN chmod +x /auto.sh

#Creates the web root directory and sets ownership to www-data, 
#which NGINX uses to serve WordPress content.
RUN mkdir -p /var/www/wordpress

RUN chown -R www-data:www-data /var/www/wordpress

ENTRYPOINT [ "./auto.sh" ]

#tells NGINX not to run in the background (daemon mode)
CMD ["nginx", "-g", "daemon off;"]