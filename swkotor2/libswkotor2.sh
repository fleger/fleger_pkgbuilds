swkotor2.run() {
  local APP_NAME="swkotor2"
  local TMPDIR="${TMPDIR:-/tmp}"
  local RW_BRANCH="${XDG_DATA_HOME}/${APP_NAME}"
  local APP_DIR="${TMPDIR}/${APP_NAME}-tmp-${USER}"
  local BRANCHES_D="/etc/${APP_NAME}.d"
  local __firstRun=false

  if [ ! -d "${RW_BRANCH}" ]; then
    __firstRun=true
  fi

  mkdir -p "${RW_BRANCH}" "${APP_DIR}" &&
  RW_BRANCH="${RW_BRANCH}" modfs -o cow -o "uid=${UID}" -o "gid=${GROUPS[0]}" "${BRANCHES_D}" "${APP_DIR}" &&
  cd "${APP_DIR}" &&
  "$@"

  cd / &&
  fusermount -u "${APP_DIR}" &&
  rmdir "${APP_DIR}"
}

swkotor2.firstRun() {
  "${__firstRun}"
}
