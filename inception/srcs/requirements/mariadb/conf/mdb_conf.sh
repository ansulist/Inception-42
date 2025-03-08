#!/bin/bash
#change the default shell to szh
#bcs of ..
chsh -s $(which zsh)
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
echo "alias zshi='sh /install.sh'" >> ~/.zshrc

#starts the mariadb service
service mariadb start
#wait till the mariadb starts
sleep 5

#create the database, user, and set ut permission based on ENV variable
mariadb -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DB}\`;"
mariadb -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mariadb -e "GRANT ALL PRIVILEGES ON ${MYSQL_DB}.* TO \`${MYSQL_USER}\`@'%';"
mariadb -e "FLUSH PRIVILEGES;"

#afterfinish, will shut down the mariadb after the setup
mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown
#then restart the mariadb in SAFE mode with above options, to allow remote connection
mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql'
