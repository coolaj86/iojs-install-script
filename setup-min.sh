#!/bin/bash

# Installs node.js only (no development dependencies) for both Ubuntu and OS X

#
# See https://github.com/coolaj86/node-install-script
#

# curl -fsSL bit.ly/nodejs-min | bash
# wget -nv bit.ly/nodejs-min -O - | bash

# curl -fsSL https://example.com/setup-min.bash | bash
# wget -nv https://example.com/setup-min.bash -O - | bash

NODEJS_NAME="node"
NODEJS_BASE_URL="https://nodejs.org"
BASE_URL="https://raw.githubusercontent.com/coolaj86/node-install-script/master"
OS="unsupported"
ARCH=""
NODEJS_VER=""
SETUP_FILE=""

clear

#########################
# Which OS and version? #
#########################

if [ "$(uname | grep -i 'Darwin')" ]; then
  OSX_VER="$(sw_vers | grep ProductVersion | cut -d':' -f2 | cut -f2)"
  OSX_MAJOR="$(echo ${OSX_VER} | cut -d'.' -f1)"
  OSX_MINOR="$(echo ${OSX_VER} | cut -d'.' -f2)"
  OSX_PATCH="$(echo ${OSX_VER} | cut -d'.' -f3)"

  #
  # Major
  #
  if [ "$OSX_MAJOR" -lt 10 ]; then
    echo "unsupported OS X version (os 9-)"
    exit 1
  fi

  if [ "$OSX_MAJOR" -gt 10 ]; then
    echo "unsupported OS X version (os 11+)"
    exit 1
  fi

  #
  # Minor
  #
  if [ "$OSX_MINOR" -le 5 ]; then
    echo "unsupported OS X version (os 10.5-)"
    exit 1
  fi

  # Snow
  if [ "$OSX_MINOR" -eq 6 ]; then
    OS='snow'
  fi

  # Lion
  if [ $OSX_MINOR -eq 7 ]; then
    OS='lion'
  fi

  # Mountain Lion
  if [ "$OSX_MINOR" -eq 8 ]; then
    OS='mountain'
  fi

  # Mavericks, Yosemite
  if [ "$OSX_MINOR" -ge 9 ]; then
    OS='mavericks'
  fi

  if [ -n "$(sysctl hw | grep 64bit | grep ': 1')" ]; then
    ARCH="64"
  else
    ARCH="32"
  fi
elif [ "$(uname | grep -i 'Linux')" ]; then
  if [ ! -f "/etc/issue" ]; then
    echo "unsupported linux os"
    exit 1
  fi

  if [ -n "$(arch | grep 64)" ]; then
    ARCH="64"
  else
    ARCH="32"
  fi

  if [ "$(cat /etc/issue | grep -i 'Ubuntu')" ]; then
    OS='ubuntu'
  elif [ "$(cat /etc/issue | grep -i 'Raspbian')" ]; then
    OS='raspbian'
  elif [ "$(cat /etc/issue | grep -i 'Fedora')" ]; then
    OS='fedora'
  fi
else
  echo "unsupported unknown os (non-mac, non-linux)"
  exit 1
fi

case "${OS}" in
  fedora)
    echo "FEDORA not yet supported (feel free to pull request)"
    exit 1
    ;;
  ubuntu)
    SETUP_FILE="ubuntu"
    ;;
  raspbian)
    SETUP_FILE="ubuntu"
    ;;
  yosemite)
    # mavericks
    SETUP_FILE="mavericks"
    ;;
  mavericks)
    SETUP_FILE="mavericks"
    ;;
  mountain)
    echo "Mountain Lion not yet supported (feel free to pull request)"
    exit 1
    ;;
  lion)
    echo "Lion not yet supported (feel free to pull request)"
    exit 1
    ;;
  snow)
    echo "Snow Leopard not yet supported (feel free to pull request)"
    exit 1
    ;;
  *)
    echo "unsupported unknown os ${OS}"
    exit 1
    ;;
esac

#######################
# Download installers #
#######################

echo "Preparing to install io.js (and common development dependencies) for ${OS}" "${ARCH}"

INSTALL_FILE="setup-node-${SETUP_FILE}.bash"
if [ ! -e "/tmp/${INSTALL_FILE}" ]
then
  if [ -n "$(which curl)" ]; then
    curl --silent "${BASE_URL}/${INSTALL_FILE}" \
      -o "/tmp/${INSTALL_FILE}" || echo 'error downloading os setup script'
  elif [ -n "$(which wget)" ]; then
    wget --quiet "${BASE_URL}/${INSTALL_FILE}" \
      -O "/tmp/${INSTALL_FILE}" || echo 'error downloading os setup script'
  else
    echo "Found neither 'curl' nor 'wget'. Can't Continue."
    exit 1
  fi
fi

if [ ! -e "/tmp/${INSTALL_FILE}" ]
then
  echo "Error Downloading Install File"
  exit 1
fi

#########################
# Which io.js VERSION ? #
#########################

if [ -f "/tmp/NODEJS_VER" ]; then
  NODEJS_VER=$(cat /tmp/NODEJS_VER | grep v)
elif [ -f "/tmp/IOJS_VER" ]; then
  NODEJS_VER=$(cat /tmp/IOJS_VER | grep v)
fi

if [ -n "$NODEJS_VER" ]; then
  NODEJS_VERT=$(echo ${NODEJS_VER} | cut -c 2- | cut -d '.' -f1)

  if [ $NODEJS_VERT -ge 1 ] && [ $NODEJS_VERT -lt 4 ]
  then
    echo "Selecting io.js instead of node.js for this version (>= 1.0.0 < 4.0.0)"
    NODEJS_BASE_URL="https://iojs.org"
    NODEJS_NAME="iojs"
  fi
fi

if [ -z "$NODEJS_VER" ]; then
  if [ -n "$(which curl)" ]; then
    NODEJS_VER=$(curl -fsSL "$NODEJS_BASE_URL/dist/index.tab" | head -2 | tail -1 | cut -f 1) \
      || echo 'error automatically determining current io.js version'
  elif [ -n "$(which wget)" ]; then
    NODEJS_VER=$(wget --quiet "$NODEJS_BASE_URL/dist/index.tab" -O - | head -2 | tail -1 | cut -f 1) \
      || echo 'error automatically determining current io.js version'
  else
    echo "Found neither 'curl' nor 'wget'. Can't Continue."
    exit 1
  fi
fi

#
# iojs
#
if [ -n "$(which iojs | grep iojs 2>/dev/null)" ]; then
# iojs of some version is already installed
  if [ "${NODEJS_VER}" == "$(iojs -v 2>/dev/null)" ]; then
    echo iojs ${NODEJS_VER} is already installed
  else
    echo ""
    echo "HEY, LISTEN:"
    echo ""
    echo "io.js is already installed as iojs $(iojs -v | grep v)"
    echo ""
    echo "to reinstall please first run: rm $(which iojs)"
    echo ""
  fi
  NODEJS_VER=""
elif [ "$(node -v 2>/dev/null)" != "$(iojs -v 2>/dev/null)" ]; then
# node of some version is already installed
  echo ""
  echo "HEY, LISTEN!"
  echo ""
  echo "You have node.js installed."
  echo "Backing up $(which node) as $(which node).$(node -v)"
  echo "(copy it back after the install to maintain node.js and io.js separately)"
  echo ""
  sleep 3
  NODE_PATH=$(which node)
  NODE_VER=$(node -v)
  echo sudo mv "$NODE_PATH" "$NODE_PATH.$NODE_VER"
  sudo mv "$NODE_PATH" "$NODE_PATH.$NODE_VER"
  echo "################################################################################"
  echo "to restore backup: sudo rsync -a '"$NODE_PATH.$NODE_VER"' '$NODE_PATH'"
  echo "################################################################################"
  echo ""
fi

if [ -n "${NODEJS_VER}" ]; then
  bash "/tmp/${INSTALL_FILE}" "${NODEJS_VER}"
fi

echo ""
