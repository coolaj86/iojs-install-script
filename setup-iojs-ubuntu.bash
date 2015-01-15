IOJS_VER=${1}

if [ -n "$(arch | grep 64)" ]; then
  ARCH="x64"
else
  ARCH="x86"
fi

if [ -n "${IOJS_VER}" ]; then
  echo "installing io.js as iojs ${IOJS_VER}..."

  curl -fsSL "http://iojs.org/dist/${IOJS_VER}/iojs-${IOJS_VER}-linux-${ARCH}.tar.gz" \
    -o "/tmp/iojs-${IOJS_VER}-linux-${ARCH}.tar.gz"
  pushd /tmp >/dev/null
  tar xf /tmp/iojs-${IOJS_VER}-linux-${ARCH}.tar.gz
  rm iojs-${IOJS_VER}-linux-x64/{LICENSE,CHANGELOG.md,README.md}
  sudo rsync -a "/tmp/iojs-${IOJS_VER}-linux-${ARCH}/" /usr/local/


  sudo chown -R $(whoami) /usr/local
fi
