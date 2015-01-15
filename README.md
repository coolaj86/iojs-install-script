# iojs-install-script

A script to install basic development tools for iojs (git, iojs, gcc, pkg-config, etc)

Works for any recent version of Ubuntu or OS X.

```bash
# Specify the version of iojs to install
echo "v1.0.1" > /tmp/IOJS_VER

# And install away!
curl -fsSL bit.ly/install-iojs | bash
```

**For older versions of Ubuntu**:

```bash
wget -nv bit.ly/install-iojs -O - | bash
```

This is what gets installed:

* rsync
* curl
* wget
* git
* xcode / brew / build-essential / pkg-config / gcc
* iojs (including npm and node symlink)
* jshint

If `fail2ban` is not already securing ssh, you will be asked to install it.

Screencast
==========

[How to Setup a VPS for io.js Development](https://www.youtube.com/watch?v=ypjzi1axH2A) - [(3:06 installing io.js](https://www.youtube.com/watch?v=ypjzi1axH2A#t=186))

Front-End Extras
================

These are **not installed**, but you may wish to use them if you're doing front-end work as well

* bower
* uglifyjs
* yo
* jade
* less
