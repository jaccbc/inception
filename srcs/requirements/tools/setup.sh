#!/usr/bin/env bash

set -e

if [ -z $ENV ]; then
	echo "Error: empty environment variable"
	exit 1
fi

read -p "Enter your intra login: " LOGIN
if [ -z "$LOGIN" ]; then
	if [ -z "$USER" ]; then
		echo "Error: no login"
		exit 1
	fi
	LOGIN=$USER
	echo "LOGIN set as $USER"
fi

if ! grep -q "$LOGIN.42.fr" /etc/hosts; then
  echo "127.0.0.42 $LOGIN.42.fr" | sudo tee -a /etc/hosts > /dev/null
fi

ROOT_DIR=$(git rev-parse --show-toplevel)
if [ ! -d "$ROOT_DIR" ]; then
	echo "Error: could not fetch project root directory"
	exit 1
fi

echo "ROOT_DIR=$ROOT_DIR" > "$ENV"
echo "LOGIN=$LOGIN" >> "$ENV"
echo "DOMAIN=$LOGIN.42.fr" >> "$ENV"
echo "VOLUME=/home/$LOGIN/data" >> "$ENV"
echo "OS_VERSION=$(curl -s https://dl-cdn.alpinelinux.org/alpine/ | grep -o 'v[0-9]\+\.[0-9]\+' | sort -t. -k2,2n -u | tail -n2 | head -n1 | cut -dv -f2)" >> "$ENV"
echo "DB_NAME=inception" >> "$ENV"
echo "DB_USER=$(tr -dc 'a-z0-9' < /dev/urandom | head -c 7)" >> "$ENV"
echo "WP_ADMIN=$(tr -dc 'a-z0-9' < /dev/urandom | head -c 7)" >> "$ENV"
echo "WP_USER=$(tr -dc 'a-z0-9' < /dev/urandom | head -c 7)" >> "$ENV"
MYSQL_UID=$(id mysql | grep -o 'uid=[0-9]\+')
MYSQL_GID=$(id mysql | grep -o 'gid=[0-9]\+')
echo "MYSQL_${MYSQL_UID^^}" >> "$ENV"
echo "MYSQL_${MYSQL_GID^^}" >> "$ENV"


SECRETS="$ROOT_DIR/.secrets"
mkdir -p "$SECRETS"
if [ -d "$SECRETS" ]; then
	openssl rand -base64 42 > "$SECRETS/db_root_password.txt"
	openssl rand -base64 42 > "$SECRETS/db_password.txt"
	openssl rand -base64 42 > "$SECRETS/admin_password.txt"
	openssl rand -base64 42 > "$SECRETS/user_password.txt"
  openssl req -x509 -nodes -days 42 -newkey rsa:4096 \
    --keyout $SECRETS/self-signed.key \
    --out $SECRETS/self-signed.crt \
    -subj "/C=PT/ST=Lisbon/L=Lisbon/O=42Network/OU=42Lisboa/CN=$LOGIN.42.fr" \
    > /dev/null 2>&1
else
	rmdir "$SECRETS" "$ENV"
	echo "Error: unable to make .secrets"
	exit 1
fi

VOLUME="$(grep VOLUME $ENV | cut -d= -f2)"
if [ ! -d "$VOLUME" ]; then
    sudo mkdir -p "$VOLUME/db" "$VOLUME/wp"
    if [ $? != 0 ]; then
      rm "$SECRETS" "$ENV"
      echo "Error: unable to make $VOLUME data"
      exit 1
    fi
    sudo chown -R mysql:mysql "$VOLUME/db"
fi
