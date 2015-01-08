#!/bin/bash

# curl -fsSL https://example.com/setup.bash | bash
# wget -nv https://example.com/setup.bash -O - | bash

BASE_URL="https://raw.githubusercontent.com/coolaj86/node-install-script/master"
NODE_VER="v0.11.14"
OS="unsupported"
ARCH=""

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
    echo "sudo yum"
    echo "wget --quiet ${BASE_URL}/setup-fedora.bash -O /tmp/install-node.bash || echo 'error downloading os setup script'"
    ;;
  ubuntu)
    wget --quiet "${BASE_URL}/setup-ubuntu.bash" -O /tmp/install-node.bash || echo 'error downloading os setup script'
    ;;
  yosemite)
    # mavericks
    curl --silent "${BASE_URL}/setup-mavericks.bash" -o /tmp/install-node.bash || echo 'error downloading os setup script'
    ;;
  mavericks)
    curl --silent "${BASE_URL}/setup-mavericks.bash" -o /tmp/install-node.bash || echo 'error downloading os setup script'
    ;;
  mountain)
    echo "wget cltools"
    echo "curl --silent ${BASE_URL}/setup-mountain.bash -o /tmp/install-node.bash || echo 'error downloading os setup script'"
    ;;
  lion)
    echo "wget cltools"
    echo "curl --silent ${BASE_URL}/setup-lion.bash -o /tmp/install-node.bash || echo 'error downloading os setup script'"
    ;;
  snow)
    echo "wget gcc-0.6.pkg"
    echo "curl --silent ${BASE_URL}/setup-snow.bash -o /tmp/install-node.bash || echo 'error downloading os setup script'"
    ;;
  *)
    echo "unsupported unknown os ${OS}"
    exit 1
    ;;
esac

echo "${OS}" "${ARCH}"
bash /tmp/install-node.bash "${NODE_VER}"

# jshint
if [ -z "$(which jshint | grep jshint)" ]; then
  echo "installing jshint..."
  npm install --silent jshint -g > /dev/null
else
  echo "jshint already installed"
fi

echo ""
