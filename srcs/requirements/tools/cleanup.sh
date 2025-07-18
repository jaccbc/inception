#!/usr/bin/env bash

set -eu

if ! which sudo > /dev/null 2>&1; then
  echo "Error: sudo not found"
  exit 1
elif ! sudo -l > /dev/null 2>&1; then
  echo "Error: you need sudo permissions to run the script"
  exit 1
elif ! id $(id -un) | grep -q docker; then
	echo "Error: you need to be in the docker group"
	exit 1
fi

if [ ! -f "$ENV" ]; then
	exit 0
fi

SECRETS="$(grep ROOT_DIR $ENV | cut -d= -f2)/.secrets"
if [ -d "$SECRETS" ]; then
  rm -rf "$SECRETS"
fi

if docker volume ls | grep -oq 'inception_[a-z-]\+'; then
  docker volume rm $(docker volume ls | grep -o 'inception_[a-z-]\+')
fi

VOLUME="$(grep VOLUME $ENV | cut -d= -f2)"
if [ -d "$VOLUME" ]; then
  read -p "Do you want to permanently delete your volume data? [y/N] " RESULT
  if [ -n "$RESULT" ] && [ $RESULT == "y" ] ; then
    sudo rm -rf "$VOLUME"
    echo "Directory $VOLUME was deleted!"
  fi
fi

DOMAIN="$(grep DOMAIN $ENV | cut -d= -f2)"
if grep -q "127.0.0.42 $DOMAIN" /etc/hosts; then
  sudo sed -i "/127.0.0.42 $DOMAIN/d" /etc/hosts
fi

if [ -f "$ENV" ]; then
  rm -rf "$ENV"
fi
