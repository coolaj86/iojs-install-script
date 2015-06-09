# Automated io.js installers for OS X and Ubuntu

A script to install basic development tools for io.js - the new node.js - git, iojs, gcc, pkg-config, etc

Pick one:

* [OS X](#apple-os-x)
* [Ubuntu Linux](#ubuntu-linux)
* [TL;DR](#tldr)
* [Important Notes](#other-things-you-should-know)

## Screencast

[How to Setup a VPS for io.js Development](https://www.youtube.com/watch?v=ypjzi1axH2A) - [(3:06 installing io.js](https://www.youtube.com/watch?v=ypjzi1axH2A#t=186))

## TL;DR

If you kinda know what you're doing already:

**io.js + dev tools**

```bash
echo "Current io.js version is $(curl -fsSL https://iojs.org/dist/index.tab | head -2 | tail -1 | cut -f 1)"
curl -fsSL bit.ly/iojs-dev -o /tmp/iojs-dev.sh; bash /tmp/iojs-dev.sh
```

**io.js only** (no git, gcc, etc)

```bash
# To install a specific version rather than defaulting to latest
echo "v1.8.2" > /tmp/IOJS_VER

# io.js without development dependencies
curl -fsSL bit.ly/iojs-min | bash

# Ubuntu without curl
wget -nv bit.ly/iojs-min -O - | bash
```

## Apple OS X

First you need to **Install XCode Command Line Tools**

```bash
xcode-select --install
```

Then you need to **Accept the XCode License** by running any command installed by Xcode with sudo. We'll use git.

```bash
sudo git --version
```

You can scroll to the bottom by hitting shift+G (capital G).

Type `agree` and hit enter to accept the license.

Now you can install io.js (the new node.js)

```bash
curl -fsSL bit.ly/iojs-dev -o /tmp/iojs-dev.sh; bash /tmp/iojs-dev.sh
```

*TODO*: Make it easier to accepting the license (automatic?)

## Ubuntu Linux

```bash
wget -nv bit.ly/iojs-dev -O /tmp/iojs-dev.sh; bash /tmp/iojs-dev.sh
```

## Other things you should know

**NOTE**: If you have node installed, this script will rename it so that it isn't overwritten by the iojs installer.

This is what gets installed:

* rsync
* curl
* wget
* git
* xcode / brew / build-essential / pkg-config / gcc
* iojs (including npm and node symlink)
* jshint

**NOTE**: If `fail2ban` is not already securing ssh, you will be asked to install it.


Front-End Extras
================

These are **not installed**, but you may wish to use them if you're doing front-end work as well

* bower
* uglifyjs
* yo
* jade
* less
