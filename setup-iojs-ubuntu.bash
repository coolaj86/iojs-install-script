IOJS_VER=${1}

if [ -n "$(arch | grep 64)" ]; then
  ARCH="x64"
else
  ARCH="x86"
fi

IOJS_REMOTE="http://iojs.org/dist/${IOJS_VER}/iojs-${IOJS_VER}-linux-${ARCH}.tar.gz"
IOJS_LOCAL="/tmp/iojs-${IOJS_VER}-linux-${ARCH}.tar.gz"
IOJS_UNTAR="/tmp/iojs-${IOJS_VER}-linux-${ARCH}"

if [ -n "${IOJS_VER}" ]; then
  echo "installing io.js as iojs ${IOJS_VER}..."

  if [ -n "$(which curl 2>/dev/null)" ]; then
    curl -fsSL ${IOJS_REMOTE} -o ${IOJS_LOCAL} || echo 'error downloading io.js'
  elif [ -n "$(which wget 2>/dev/null)" ]; then
    wget --quiet ${IOJS_REMOTE} -O ${IOJS_LOCAL} || echo 'error downloading io.js'
  else
    echo "'wget' and 'curl' are missing. Please run the following command and try again"
    echo "\tsudo apt-get install --yes curl wget"
    exit 1
  fi

  tar xf ${IOJS_LOCAL}
  rm ${IOJS_UNTAR}/{LICENSE,CHANGELOG.md,README.md}
  sudo rsync -a "${IOJS_UNTAR}/" /usr/local/


  sudo chown -R $(whoami) /usr/local
fi
