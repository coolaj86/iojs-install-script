IOJS_VER=${1}
IOJS_REMOTE="http://iojs.org/dist/${IOJS_VER}/iojs-${IOJS_VER}.pkg"
IOJS_PKG="/tmp/iojs-${IOJS_VER}.pkg"

if [ -n "${IOJS_VER}" ]; then
  echo "installing io.js as iojs ${IOJS_VER}..."
  curl -fsSL "${IOJS_REMOTE}" -o "${IOJS_PKG}"
  sudo /usr/sbin/installer -pkg "${IOJS_PKG}" -target /

  sudo chown -R $(whoami) /usr/local 2>/dev/null
fi
