NODEJS_VER=${1}
NODEJS_VERT=$(echo ${NODEJS_VER} | cut -c 2- | cut -d '.' -f1)

NODEJS_NAME="node"
NODEJS_BASE_URL="https://nodejs.org"

GE1=$(echo "$NODEJS_VERT>=1" | bc)
LT4=$(echo "$NODEJS_VERT<4" | bc)

if [ "1" -eq $GE1  ] && [ "1" -eq $LT4 ]
then
  NODEJS_BASE_URL="https://iojs.org"
  NODEJS_NAME="iojs"
fi

if [ -n "$(arch | grep 64)" ]; then
  ARCH="x64"
elif [ -n "$(arch | grep armv7l)" ]; then
  ARCH="armv7l"
elif [ -n "$(arch | grep armv6l)" ]; then
  ARCH="armv6l"
else
  ARCH="x86"
fi

NODEJS_REMOTE="${NODEJS_BASE_URL}/dist/${NODEJS_VER}/${NODEJS_NAME}-${NODEJS_VER}-linux-${ARCH}.tar.gz"
NODEJS_LOCAL="/tmp/${NODEJS_NAME}-${NODEJS_VER}-linux-${ARCH}.tar.gz"
NODEJS_UNTAR="/tmp/${NODEJS_NAME}-${NODEJS_VER}-linux-${ARCH}"

if [ -n "${NODEJS_VER}" ]; then
  echo "installing ${NODEJS_NAME} as ${NODEJS_NAME} ${NODEJS_VER}..."

  if [ -n "$(which curl 2>/dev/null)" ]; then
    curl -fsSL ${NODEJS_REMOTE} -o ${NODEJS_LOCAL} || echo 'error downloading ${NODEJS_NAME}'
  elif [ -n "$(which wget 2>/dev/null)" ]; then
    wget --quiet ${NODEJS_REMOTE} -O ${NODEJS_LOCAL} || echo 'error downloading ${NODEJS_NAME}'
  else
    echo "'wget' and 'curl' are missing. Please run the following command and try again"
    echo "\tsudo apt-get install --yes curl wget"
    exit 1
  fi

  tar xf ${NODEJS_LOCAL} -C /tmp/
  rm ${NODEJS_UNTAR}/{LICENSE,CHANGELOG.md,README.md}
  sudo rsync -a "${NODEJS_UNTAR}/" /usr/local/


  sudo chown -R $(whoami) /usr/local
fi
