#!/usr/bin/env sh

set -e

DB_ROOT_PASS=$(cat /run/secrets/db_root_password)
DB_PASS=$(cat /run/secrets/db_password)
TMP=db-boot.sql

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
exec /usr/bin/mysqld --user=mysql --console
