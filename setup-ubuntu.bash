#!/bin/bash

# curl -fsSL https://ldsconnect.org/setup-linux.bash | bash -c

IOJS_VER=${1}

echo ""
echo ""

echo "updating apt-get..."
sudo bash -c "apt-get update -qq -y < /dev/null" > /dev/null

# fail2ban
if [ -z "$(which fail2ban-server | grep fail2ban)" ]; then
  echo "installing fail2ban..."
  sudo bash -c "apt-get install -qq -y fail2ban < /dev/null" > /dev/null
fi

# git, wget, curl, build-essential
if [ -z "$(which pkg-config | grep pkg-config)" ] || [ -z "$(which git | grep git)" ] || [ -z "$(which wget | grep wget)" ] || [ -z "$(which curl | grep curl)" ] || [ -z "$(which gcc | grep gcc)" ] || [ -z "$(which rsync | grep rsync)" ]
then
  echo "installing git, wget, curl, build-essential, rsync, pkg-config..."
  sudo bash -c "apt-get install -qq -y git wget curl build-essential rsync pkg-config < /dev/null" > /dev/null 2>/dev/null
fi

# iojs
if [ -n "$(which node | grep node 2>/dev/null)" ]; then
  if [ "$(node -v 2>/dev/null)" != "$(iojs -v 2>/dev/null)" ]; then
    echo "You have node.js installed. Backing up $(which node) as $(which node).joyent"
    echo "(you can move it back after the install if you want separate node.js and io.js installations)"
    echo ""
    echo sudo mv "$(which node)" "$(which node).joyent"
    sudo mv "$(which node)" "$(which node).joyent"
  fi
  
  if [ "${IOJS_VER}" == "$(iojs -v 2>/dev/null)" ]; then
    echo iojs ${IOJS_VER} already installed
  else
    clear
    echo ""
    echo "HEY, LISTEN:"
    echo "io.js is already installed as iojs $(iojs -v | grep v)"
    echo ""
    echo "to reinstall please first run: rm $(which iojs)"
    echo ""
    IOJS_VER=""
  fi
fi

if [ -n "${IOJS_VER}" ]; then
  if [ -n "$(arch | grep 64)" ]; then
    ARCH="x64"
  else
    ARCH="x86"
  fi
  echo "installing io.js as iojs ${IOJS_VER}..."
  curl -fsSL "http://iojs.org/dist/${IOJS_VER}/iojs-${IOJS_VER}-linux-${ARCH}.tar.gz" \
    -o "/tmp/iojs-${IOJS_VER}-linux-${ARCH}.tar.gz"
  pushd /tmp
  tar xf /tmp/iojs-${IOJS_VER}-linux-${ARCH}.tar.gz
  rm iojs-${IOJS_VER}-linux-x64/{LICENSE,CHANGELOG.md,README.md}
  sudo rsync -a "/tmp/iojs-${IOJS_VER}-linux-${ARCH}/" /usr/local/
  sudo chown -R $(whoami) /usr/local
fi
