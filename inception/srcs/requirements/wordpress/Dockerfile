FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y

#downloading the external script (curl), environment to run wordpress (php and php fpm), allowing communication with mariadb(php-mysql), allowing wp container interact with madb database
RUN apt-get install -y curl php php7.4-fpm php-mysql mariadb-client wget vim zsh git netcat mycli

#copy the script to the container
COPY /conf/wp_conf.sh /

#script to be executable
RUN  chmod +x wp_conf.sh

#script should run as the main entry point when the container starts
ENTRYPOINT ["./wp_conf.sh"]