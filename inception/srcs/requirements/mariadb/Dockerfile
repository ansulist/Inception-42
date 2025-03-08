FROM debian:bullseye

#for debian upgrade
RUN apt-get update && apt-get upgrade -y

#install mariadb server and necessary tools
#zsh and mycli helping with the shell and databae management
RUN apt-get install -y mariadb-server vim zsh wget git mycli

#copy the script to the container
COPY ./conf/mdb_conf.sh /mdb_conf.sh

#make the script executable
RUN chmod +x /mdb_conf.sh

#defining the script as the main entry point that runs when the contrainer starts
ENTRYPOINT ["./mdb_conf.sh"]
