#!/usr/bin/env sh

set -eu

DB_PASS=$(cat /run/secrets/db_password)
ADMIN_PASS=$(cat /run/secrets/admin_password)
USER_PASS=$(cat /run/secrets/user_password)

wp-cli core download --allow-root

wp-cli config create --dbname=$DB_NAME --dbuser=$DB_USER \
  --dbpass=$DB_PASS --dbhost=mysql \
  --path=/var/www/html --allow-root

wp-cli core install --url=$DOMAIN --title=Inception \
  --admin_user=$WP_ADMIN --admin_password=$ADMIN_PASS \
  --admin_email=$LOGIN@student.42lisboa.com \
  --path=/var/www/html --allow-root

wp-cli user create $WP_USER $WP_USER@student.42lisboa.com \
  --user_pass=$USER_PASS --role=editor \
  --path=/var/www/html --allow-root

exec /usr/sbin/php-fpm -F
