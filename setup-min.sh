#!/bin/bash

TMP_FILE='/tmp/node-installer-new.sh'

set -e
rm -rf /tmp/node-installer-new.sh

echo "Downloading and running the new installer script from https://git.coolaj86.com/coolaj86/node-installer.sh/raw/master/install.sh"

SETUP_URL='https://git.coolaj86.com/coolaj86/node-installer.sh/raw/master/install.sh'


if [ -n "$(which curl)" ]; then
  curl --silent "$SETUP_URL" \
    -o "$TMP_FILE" || echo 'error downloading newer deps script:' "$SETUP_URL"
    
elif [ -n "$(which wget)" ]; then
  wget --quiet "$SETUP_URL" \
    -O "$TMP_FILE" || echo 'error downloading newer deps script:' "$SETUP_URL"
fi

set +e

bash $TMP_FILE
