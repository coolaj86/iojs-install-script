# Automated node.js installers for OS X and Ubuntu

A script to install basic development tools for node.js - git, node, gcc, pkg-config, etc

Pick one:

* [OS X](#apple-os-x)
* [Ubuntu Linux](#ubuntu-linux)
* [TL;DR](#tldr)
* [Important Notes](#other-things-you-should-know)

## Screencast

[How to Setup a VPS for node.js Development](https://www.youtube.com/watch?v=ypjzi1axH2A) - [(3:06 installing node.js](https://www.youtube.com/watch?v=ypjzi1axH2A#t=186))

## TL;DR

If you kinda know what you're doing already:

**node.js + dev tools**

```bash
echo "Current node.js version is $(curl -fsSL https://nodejs.org/dist/index.tab | head -2 | tail -1 | cut -f 1)"

curl -fsSL bit.ly/install-nodejs-dev -o /tmp/node-dev.sh; bash /tmp/node-dev.sh
```

<!-- bit.ly/easy-install-node -->

**node.js only** (no git, gcc, etc)

```bash
# To install a specific version rather than defaulting to latest
# latest version at time of writing are v1.8.4, v2.5.0, and v3.1.0
echo "v2.5.0" > /tmp/IOJS_VER

# node.js without development dependencies
curl -fsSL bit.ly/nodejs-min | bash

# Ubuntu without curl
wget -nv bit.ly/nodejs-min -O - | bash
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

Now you can install node.js

```bash
curl -fsSL bit.ly/install-nodejs-dev -o /tmp/node-dev.sh; bash /tmp/node-dev.sh
```

*TODO*: Make it easier to accepting the license (automatic?)

## Ubuntu Linux

```bash
wget -nv bit.ly/install-nodejs-dev -O /tmp/node-dev.sh; bash /tmp/node-dev.sh
```

## Other things you should know

This is what gets installed:

* rsync
* curl
* wget
* git
* xcode / brew / build-essential / pkg-config / gcc
* node (including npm)
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
