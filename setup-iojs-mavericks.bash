IOJS_VER=${1}

if [ -n "${IOJS_VER}" ]; then
  echo "installing io.js as iojs ${IOJS_VER}..."
  curl -fsSL "http://iojs.org/dist/${IOJS_VER}/iojs-${IOJS_VER}.pkg" -o "/tmp/iojs-${IOJS_VER}.pkg"
  sudo /usr/sbin/installer -pkg "/tmp/iojs-${IOJS_VER}.pkg" -target /


  sudo chown -R $(whoami) /usr/local 2>/dev/null
fi
