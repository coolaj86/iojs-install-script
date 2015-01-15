#!/bin/bash

# curl -fsSL https://ldsconnect.org/setup-linux.bash | bash -c

NO_FAIL2BAN=${1}

echo ""
echo ""
echo "Checking for"
echo ""
echo "    * build-essential"
echo "    * rsync"
echo "    * wget"
echo "    * curl"
echo "    * pkg-config"
echo "    * jshint"
echo ""

echo "updating apt-get..."
sudo bash -c "apt-get update -qq -y < /dev/null" > /dev/null

# fail2ban
if [ -z "$(which fail2ban-server | grep fail2ban)" ]; then
  if [ -z "${NO_FAIL2BAN}" ]; then
    echo "installing fail2ban..."
    sudo bash -c "apt-get install -qq -y fail2ban < /dev/null" > /dev/null
  fi
fi

# git, wget, curl, build-essential
if [ -z "$(which pkg-config | grep pkg-config)" ] || [ -z "$(which git | grep git)" ] || [ -z "$(which wget | grep wget)" ] || [ -z "$(which curl | grep curl)" ] || [ -z "$(which gcc | grep gcc)" ] || [ -z "$(which rsync | grep rsync)" ]
then
  echo "installing git, wget, curl, build-essential, rsync, pkg-config..."
  sudo bash -c "apt-get install -qq -y git wget curl build-essential rsync pkg-config < /dev/null" > /dev/null 2>/dev/null
fi
