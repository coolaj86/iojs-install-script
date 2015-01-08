node-install-script
===================

A script to install basic development tools for node (git, node, gcc, etc)

Works for any recent version of Ubuntu or OS X.

```bash
# Specify the version of node to install
echo "v0.11.14" > /tmp/NODE_VER

# And install away!
curl -fsSL bit.ly/easy-install-node | bash
```

**For older versions of Ubuntu**:

```bash
wget -nv bit.ly/easy-install-node -O - | bash
```

This is what gets installed:

* fail2ban (not necessary for development, but should be on every server)
* rsync
* curl
* wget
* git
* xcode / brew / build-essential / pkg-config / gcc
* node
* jshint

Screencast
==========

[How to Setup a VPS for Node.js Development](https://www.youtube.com/watch?v=ypjzi1axH2A) - [(3:06 installing node](https://www.youtube.com/watch?v=ypjzi1axH2A#t=186))

Front-End Extras
================

These are **not installed**, but you may wish to use them if you're doing front-end work as well

* bower
* uglifyjs
* yo
* jade
* less
