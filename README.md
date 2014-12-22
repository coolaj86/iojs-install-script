node-install-script
===================

A script to install basic development tools for node (git, node, gcc, etc)

Works for any recent version of Ubuntu or OS X.

```bash
curl -fsSL bit.ly/easy-install-node | bash


# For older version of ubuntu
wget -nv bit.ly/easy-install-node -O - | bash
```

This is what gets installed:

* fail2ban (not necessary for development, but should be on every server)
* rsync
* curl
* wget
* git
* xcode / build-essential / gcc
* node
* jshint
* bower
* uglifyjs
* yo
* jade
* less
