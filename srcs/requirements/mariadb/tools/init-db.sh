#!/bin/sh
set -e

DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_PASSWORD=$(cat /run/secrets/db_password)

if [ ! -d "/var/lib/mysql/mysql" ]; then
	mariadb-install-db \
		--user=mysql \
		--datadir=/var/lib/mysql \
		--auth-root-authentication-method=normal

	mysqld --user=mysql --skip-networking &
	pid=$!

	mariadb-admin --user=root --wait=30 ping

	mariadb --user=root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

	mariadb-admin --user=root --password="${DB_ROOT_PASSWORD}" shutdown
	wait "$pid"
fi

exec mysqld --user=mysql --console
