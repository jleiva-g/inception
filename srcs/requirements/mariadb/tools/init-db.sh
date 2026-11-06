#!/bin/sh
set -e

DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_PASSWORD=$(cat /run/secrets/db_password)

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db \
        --user=mysql \
        --datadir=/var/lib/mysql \
        --auth-root-authentication-method=normal
fi

mysqld --user=mysql --skip-networking &
pid=$!

until mariadb-admin --user=root ping --silent; do
    sleep 1
done

if ! mariadb -u root -e "SELECT 1" >/dev/null 2>&1; then
    mariadb -u root -p"$DB_ROOT_PASSWORD" -e "SELECT 1"
fi

mariadb -u root -p"$DB_ROOT_PASSWORD" <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%'
IDENTIFIED BY '${DB_PASSWORD}';

ALTER USER '${MYSQL_USER}'@'%'
IDENTIFIED BY '${DB_PASSWORD}';

GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF

mariadb-admin -u root -p"$DB_ROOT_PASSWORD" shutdown
wait "$pid"

exec mysqld --user=mysql --console
