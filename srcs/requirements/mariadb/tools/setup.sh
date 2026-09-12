#!/bin/sh

set -e

sed -i 's/127\.0\.0\.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf

if [ -f /var/lib/mysql/.init_db_done ]; then
	exec mysqld_safe
fi

MYSQL_PASSWORD="$(cat /run/secrets/db_password)"

service mariadb start

sleep 5

mariadb -uroot -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE:?missing};"
mariadb -uroot -e "CREATE USER IF NOT EXISTS '${MYSQL_USER:?missing}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD:?missing}';"
mariadb -uroot -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE:?missing}.* TO '${MYSQL_USER:?missing}'@'%';"
mariadb -uroot -e "FLUSH PRIVILEGES;"

mysqladmin -uroot shutdown

chown -R mysql:mysql /var/lib/mysql/

touch /var/lib/mysql/.init_db_done

exec mysqld_safe
