#!/usr/bin/env sh

set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
  DB_ROOT_PASS=$(cat /run/secrets/db_root_password)
  DB_PASS=$(cat /run/secrets/db_password)
  TMP=db-boot.sql

  mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
  echo "USE mysql;" > ${TMP}
  echo "FLUSH PRIVILEGES;" >> ${TMP}
  echo "DELETE FROM mysql.user WHERE User='';" >> ${TMP}
  echo "DROP DATABASE IF EXISTS test;" >> ${TMP}
  echo "DELETE FROM mysql.db WHERE Db='test';" >> ${TMP}
  echo "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');" >> ${TMP}
  echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';" >> ${TMP}
  echo "CREATE DATABASE ${DB_NAME};" >> ${TMP}
  echo "CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';" >> ${TMP}
  echo "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';" >> ${TMP}
  echo "FLUSH PRIVILEGES;" >> ${TMP}
  /usr/bin/mysqld --user=mysql --bootstrap < ${TMP}
  rm -f ${TMP}
fi

usermod -u $MYSQL_UID mysql && groupmod -g $MYSQL_GID mysql
mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld /var/lib/mysql

exec /usr/bin/mariadbd --user=mysql --console
