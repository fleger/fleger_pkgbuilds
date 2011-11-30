aoe.run() {
  local -r WINEPREFIX="${WINEPREFIX:-$HOME/.wine}"
  local AOE_CD="/media/sr0"
  local -r APP_NAME="aoe"
  local -r APP_USR="/usr/share/games/aoe"
  local -r TMPDIR="${TMPDIR:-/tmp}"
  local RW_BRANCH="${XDG_DATA_HOME:-${HOME}/.local/share}/${APP_NAME}"
  local -r CONF_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/${APP_NAME}"
  local -r APP_DIR="${TMPDIR}/${APP_NAME}-tmp-${USER}"
  local -r APP_DIR_WINE="$(winepath -w "${APP_DIR}")"
  local -r BRANCHES_D="/etc/${APP_NAME}.d"
  local __firstRun=false
  local __aoeDrive=""
  local __i
  local __tmpReg

  # Setup registry
  if [ ! -d "${RW_BRANCH}" ] || ! regedit /E /dev/null "HKEY_LOCAL_MACHINE\Software\Microsoft\Games\Age of Empires\1.00" &> /dev/null; then
    __firstRun=true
    __tmpReg="$(mktemp)" &&
    sed -e "s|@APP_DIR_WINE@|${APP_DIR_WINE//\\/\\\\\\\\}|g" "${APP_USR}/${APP_NAME}.reg.in" > "${__tmpReg}" &&
    regedit "${__tmpReg}" &&
    rm "${__tmpReg}"
  fi

  # Mount CD
  [ -f "${CONF_DIR}/cdrom.conf" ] &&
  AOE_CD="$(< "${CONF_DIR}/cdrom.conf")"
  
  for __i in {d..y}; do
    [ ! -e "${WINEPREFIX}/dosdevices/${__i}:" ] &&
    __aoeDrive="${__i}:" &&
    break
  done &&
  aoe.isCDMounted &&
  ln -s "${AOE_CD}" "${WINEPREFIX}/dosdevices/${__aoeDrive}" &&
  __tmpReg="$(mktemp)" && {
    cat > "${__tmpReg}" << EOF
[HKEY_LOCAL_MACHINE\Software\Wine\Drives]
 "${AOE_DRIVE,,*}"="cdrom"

[HKEY_LOCAL_MACHINE\Software\Microsoft\Games\Age Of Empires\1.00]
"CDPath"="${__aoeDrive}\\\\"
EOF
  } &&
  regedit "${__tmpReg}" &&
  rm "${__tmpReg}" ||
  echo "No free drive letters. The CDROM will not be used." 1>&2

  # Mount the union
  mkdir -p "${RW_BRANCH}" "${APP_DIR}" &&
  RW_BRANCH="${RW_BRANCH}" modfs -o cow -o "uid=${UID}" -o "gid=${GROUPS[0]}" "${BRANCHES_D}" "${APP_DIR}" &&

  # Run the application
  cd "${APP_DIR}" &&
  "$@"

  # Unmount the union
  cd / &&
  fusermount -u "${APP_DIR}" &&
  rmdir "${APP_DIR}"

  # Cleanup wine drives
  aoe.isCDMounted &&
  rm "${WINEPREFIX}/dosdevices/${__aoeDrive}"
}

aoe.firstRun() {
  "${__firstRun}"
}

aoe.isCDMounted() {
  [ "x${__aoeDrive}" != "x" ]
}
