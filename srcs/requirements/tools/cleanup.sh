#!/usr/bin/env bash

set -e

if [ -z $ENV ]; then
	echo "Error: empty environment variable"
	exit 1
fi

SECRETS=$(grep ROOT_DIR $ENV | cut -d= -f2)/.secrets
if [ -d "$SECRETS" ]; then
	rm -rf "$SECRETS"
fi

if [ -f $ENV ]; then
	rm $ENV
fi
