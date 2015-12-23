NODEJS_VER=${1}
NODEJS_VERT=$(echo ${NODEJS_VER} | cut -c 2- | cut -d '.' -f1)

NODEJS_NAME="node"
NODEJS_BASE_URL="https://nodejs.org"


if [ $NODEJS_VERT -ge 1 ] && [ $NODEJS_VERT -lt 4 ]
then
  echo "Selecting io.js instead of node.js for this version (>= 1.0.0 < 4.0.0)"
  NODEJS_BASE_URL="https://iojs.org"
  NODEJS_NAME="iojs"
fi

NODEJS_REMOTE="$NODEJS_BASE_URL/dist/${NODEJS_VER}/${NODEJS_NAME}-${NODEJS_VER}.pkg"
NODEJS_PKG="/tmp/${NODEJS_NAME}-${NODEJS_VER}.pkg"

if [ -n "${NODEJS_VER}" ]; then
  echo "installing ${NODEJS_NAME} as ${NODEJS_NAME} ${NODEJS_VER}..."
  curl -fsSL "${NODEJS_REMOTE}" -o "${NODEJS_PKG}"
  sudo /usr/sbin/installer -pkg "${NODEJS_PKG}" -target /

  sudo chown -R $(whoami) /usr/local 2>/dev/null
fi
