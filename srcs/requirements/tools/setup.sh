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
ROOT_DIR=$(git rev-parse --show-toplevel)
if [ ! -d "$ROOT_DIR" ]; then
	echo "Error: could not fetch project root directory"
	exit 1
fi

echo "ROOT_DIR=$ROOT_DIR" > $ENV
echo "LOGIN=$LOGIN" >> $ENV
echo "DOMAIN=$LOGIN.42.fr" >> $ENV
echo "VOLUME=/home/$LOGIN/data" >> $ENV
echo "OS_VERSION=$(curl -s https://dl-cdn.alpinelinux.org/alpine/ | grep -o 'v[0-9]\+\.[0-9]\+' | sort -u | sort -n | tail -n2 | head -n1 | cut -dv -f2)" >> $ENV
echo "DB_USER=$(tr -dc 'a-zA-Z' < /dev/urandom | head -c 10)" >> $ENV
echo "DB_NAME=$(tr -dc 'a-z0-9A-Z' < /dev/urandom | head -c 10)" >> $ENV
echo "WP_ADMIN=$(tr -dc 'a-z0-9A-Z' < /dev/urandom | head -c 10)" >> $ENV
echo "WP_USER=$(tr -dc 'a-z0-9A-Z' < /dev/urandom | head -c 10)" >> $ENV

SECRETS=$ROOT_DIR/.secrets
mkdir -p $SECRETS
if [ -d "$SECRETS" ]; then
	openssl rand -base64 42 > "$SECRETS/db_root_password.txt"
	openssl rand -base64 42 > "$SECRETS/db_password.txt"
	openssl rand -base64 42 > "$SECRETS/admin_password.txt"
	openssl rand -base64 42 > "$SECRETS/user_password.txt"
else
	rmdir $SECRETS $ENV
	echo "Error: unable to make .secrets"
	exit 1
fi
