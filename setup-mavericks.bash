#!/bin/bash

# curl -fsSL https://ldsconnect.org/setup-osx.bash | bash -c
NODE_VER=${1}

echo ""
echo ""

# XCode
# testing for which git, gcc, etc will not work because the tools are aliased to the install script
if [ -z "$(xcode-select --print-path 2>/dev/null)" ] || [ -z "$(git --version 2>/dev/null)" ]; then
  echo "Hey You!!!"
  echo ""
  echo "A thingy is going to pop up and ask you to install 'command line developer tools' for 'xcode-select'"
  echo ""
  echo "You need to click Install. This installation should begin when that finishes."
  echo "(if that box doesn't pop up in a second or two, something went wrong)"
  echo "(note that it may pop up underneath this window, so check for it in the dock too)"
  echo ""

  xcode-select --install 2>/dev/null

  while true; do
    sleep 5

    if [ -n "$(git --version 2>/dev/null)" ] && [ -n "$(xcode-select --print-path 2>/dev/null)" ]; then
      break;
    fi
  done

  echo "It looks like the other install is finishing up."
  echo "This installation will begin in one minute."
  sleep 60
else
  echo "XCode Command Line Tools already installed"
fi

# homebrew
if [ -z "$(which brew | grep brew)" ]; then
  echo "installing brew (homebrew)..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew doctor
else
  echo "updating brew..."
  brew update >/dev/null 2>/dev/null
fi

if [ -z "$(which wget | grep wget)" ]; then
  echo "installing wget..."
  brew install wget
else
  echo "wget already installed"
fi

# http://www.fail2ban.org/wiki/index.php/HOWTO_Mac_OS_X_Server_(10.5)
if [ -z "$(which fail2ban-server | grep fail2ban)" ]; then
  echo "installing fail2ban..."
  brew install fail2ban
  sudo cp -fv /usr/local/opt/fail2ban/*.plist /Library/LaunchDaemons
  sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.fail2ban.plist
else
  echo "fail2ban already installed"
fi

if [ -z "$(which pkg-config | grep pkg-config)" ]; then
  echo "installing pkg-config..."
  brew install pkg-config
else
  echo "pkg-config already installed"
fi

# node
if [ -n "$(which node | grep node 2>/dev/null)" ]; then
  NODE_VER=""
  
  if [ "${NODE_VER}" == "$(node -v 2>/dev/null)" ]; then
    echo node ${NODE_VER} already installed
  else
    echo ""
    echo "HEY, LISTEN:"
    echo "node is already installed as $(node -v | grep v)"
    echo ""
    echo "to reinstall please first run: rm $(which node)"
    echo ""
  fi
fi

if [ -n "${NODE_VER}" ]; then
  echo "installing node ${NODE_VER}..."
  curl -fsSL "http://nodejs.org/dist/${NODE_VER}/node-${NODE_VER}.pkg" -o "/tmp/node-${NODE_VER}.pkg"
  sudo /usr/sbin/installer -pkg "/tmp/node-${NODE_VER}.pkg" -target /
  sudo chown -R $(whoami) /usr/local
fi
