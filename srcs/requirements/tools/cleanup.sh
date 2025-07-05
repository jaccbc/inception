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
   rm -rf "$VOLUME"
fi

if [ -f "$ENV" ]; then
	rm -rf "$ENV"
fi
