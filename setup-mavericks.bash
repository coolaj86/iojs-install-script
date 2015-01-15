#!/bin/bash

# curl -fsSL https://ldsconnect.org/setup-osx.bash | bash -c
IOJS_VER=${1}

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
  clear
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
    clear
    echo ""
    echo "I don't think you understand. This is important."
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
    else
      echo "Phew, dodged the bullet on that one... Installing fail2ban.. :-)"
      brew install fail2ban
      sudo cp -fv /usr/local/opt/fail2ban/*.plist /Library/LaunchDaemons
      sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.fail2ban.plist
    fi
  else
    brew install fail2ban
    sudo cp -fv /usr/local/opt/fail2ban/*.plist /Library/LaunchDaemons
    sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.fail2ban.plist
  fi
fi

if [ -z "$(which pkg-config | grep pkg-config)" ]; then
  echo "installing pkg-config..."
  brew install pkg-config
else
  echo "pkg-config already installed"
fi

# iojs
if [ -n "$(which node | grep node 2>/dev/null)" ]; then
  IOJS_VER=""
  
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
  fi
fi

if [ -n "${IOJS_VER}" ]; then
  echo "installing io.js as iojs ${IOJS_VER}..."
  curl -fsSL "http://iojs.org/dist/${IOJS_VER}/iojs-${IOJS_VER}.pkg" -o "/tmp/iojs-${IOJS_VER}.pkg"
  sudo /usr/sbin/installer -pkg "/tmp/iojs-${IOJS_VER}.pkg" -target /
  sudo chown -R $(whoami) /usr/local 2>/dev/null
fi
