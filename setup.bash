#!/bin/bash

# Installs iojs + dependencies for both Ubuntu and OS X

#
# See https://github.com/coolaj86/iojs-install-script
#

# curl -fsSL https://example.com/setup.bash | bash
# wget -nv https://example.com/setup.bash -O - | bash

BASE_URL="https://raw.githubusercontent.com/coolaj86/iojs-install-script/master"
NO_FAIL2BAN=""
OS="unsupported"
ARCH=""
IOJS_VER=""
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

if [ -n "$(which curl)" ]; then
  curl --silent "${BASE_URL}/setup-deps-${SETUP_FILE}.bash" \
    -o /tmp/install-iojs-deps.bash || echo 'error downloading os setup script'
  curl --silent "${BASE_URL}/setup-iojs-${SETUP_FILE}.bash" \
    -o /tmp/install-iojs.bash || echo 'error downloading os setup script'
elif [ -n "$(which wget)" ]; then
  wget --quiet "${BASE_URL}/setup-deps-${SETUP_FILE}.bash" \
    -O /tmp/install-iojs-deps.bash || echo 'error downloading os setup script'
  wget --quiet "${BASE_URL}/setup-iojs-${SETUP_FILE}.bash" \
    -O /tmp/install-iojs.bash || echo 'error downloading os setup script'
else
  echo "Found neither 'curl' nor 'wget'. Can't Continue."
  exit 1
fi




################
# DEPENDENCIES #
################

if [ -z "$(which fail2ban-server | grep fail2ban)" ]; then
  echo ""
  echo "Your server didn't come with fail2ban preinstalled!!!"
  echo "Among other things, fail2ban secures ssh so that your server isn't reaped by botnets."
  echo ""
  echo "Since you're obviosly connecting this computer to a network, you should install fail2ban before continuing"
  echo ""
  echo "Install fail2ban? [Y/n]"
  echo "(if unsure, just hit [enter])"
  read INSTALL_FAIL2BAN

  if [ "n" == "${INSTALL_FAIL2BAN}" ] || [ "no" == "${INSTALL_FAIL2BAN}" ] || [ "N" == "${INSTALL_FAIL2BAN}" ] || [ "NO" == "${INSTALL_FAIL2BAN}" ]; then
    echo ""
    echo "I don't think you understand: This is important."
    echo ""
    echo "Your server will be under constant attack by botnets via ssh."
    echo "It only takes a few extra seconds to install and the defaults are adequate for protecting you."
    echo ""
    echo "Change your mind?"
    echo "Ready to install fail2ban? [Y/n]"
    read INSTALL_FAIL2BAN
    if [ "n" == "${INSTALL_FAIL2BAN}" ] || [ "no" == "${INSTALL_FAIL2BAN}" ] || [ "N" == "${INSTALL_FAIL2BAN}" ] || [ "NO" == "${INSTALL_FAIL2BAN}" ]; then
      clear
      echo "you make me sad :-("
      sleep 0.5
      echo "but whatever, it's your funeral..."
      sleep 1
      NO_FAIL2BAN="nope"
    else
      echo "Phew, dodged the bullet on that one... Will install fail2ban.. :-)"
    fi
  fi
fi

bash /tmp/install-iojs-deps.bash "${NO_FAIL2BAN}"

#########################
# Which io.js VERSION ? #
#########################

if [ -f "/tmp/IOJS_VER" ]; then
  IOJS_VER=$(cat /tmp/IOJS_VER | grep v)
fi

if [ -z "$IOJS_VER" ]; then
  IOJS_VER="v1.0.1"
fi

#
# iojs  
#
if [ -n "$(which iojs | grep iojs 2>/dev/null)" ]; then
# iojs of some version is already installed
  if [ "${IOJS_VER}" == "$(iojs -v 2>/dev/null)" ]; then
    echo iojs ${IOJS_VER} is already installed
  else
    echo ""
    echo "HEY, LISTEN:"
    echo ""
    echo "io.js is already installed as iojs $(iojs -v | grep v)"
    echo ""
    echo "to reinstall please first run: rm $(which iojs)"
    echo ""
  fi
  IOJS_VER=""
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
  echo sudo mv "$(which node)" "$(which node).$(node -v)"
  sudo mv "$(which node)" "$(which node).$(node -v)"
  echo "################################################################################"
  echo "to restore backup: sudo rsync -a '$(which node).$(node -v)' '$(which node)'
  echo "################################################################################"
  echo ""
fi

if [ -n "${IOJS_VER}" ]; then
  bash /tmp/install-iojs.bash "${IOJS_VER}"
fi

# jshint
if [ -z "$(which jshint | grep jshint)" ]; then
  echo "installing jshint..."
  npm install --silent jshint -g > /dev/null
fi

echo ""
