#!/usr/bin/env bash

set -eu

if [ ! -f $ENV ]; then
	exit 0
fi

SECRETS="$(grep ROOT_DIR $ENV | cut -d= -f2)/.secrets"
if [ -d "$SECRETS" ]; then
	rm -rf "$SECRETS"
fi

VOLUME="$(grep VOLUME $ENV | cut -d= -f2)"
if [ -d "$VOLUME" ]; then
   sudo rm -rf "$VOLUME"
fi

DOMAIN="$(grep DOMAIN $ENV | cut -d= -f2)"
if grep "127.0.0.42 $DOMAIN" /etc/hosts; then
   sudo sed -i "/127.0.0.42 $DOMAIN/d" /etc/hosts
fi

if [ -f "$ENV" ]; then
	rm -rf "$ENV"
fi
