xvt.hooks.xvt.01-base() {
  local -r WINEPREFIX="${WINEPREFIX:-$HOME/.wine}"
  local CD_PATH="$APP_DIR"
  local -r APP_DIR_WINE="$(winepath -w "${APP_DIR}")"
  local CD_DRIVE=""
  
  if xvt.firstRun || ! regedit /E /dev/null "HKEY_LOCAL_MACHINE\Software\LucasArts Entertainment Company\X-Wing vs. TIE Fighter\1.0" &> /dev/null; then
    xvt.mergeRegistryTemplate "@APP_DIR_WINE@" "${APP_DIR_WINE//\\/\\\\}" < "${APP_USR}/${APP_NAME}-install.reg.in"
  fi

  # Alternative CD path
  [ -f "${CONF_DIR}/cdrom.conf" ] &&
  CD_PATH="$(< "${CONF_DIR}/cdrom.conf")"

  # Find a free drive letter
  local __i
  for __i in {d..y}; do
    [ ! -e "${WINEPREFIX}/dosdevices/${__i}:" ] &&
    CD_DRIVE="${__i}:" &&
    break
  done

  # Mount CD in Wine
  if [[ -n "$CD_DRIVE" ]]; then
    mkdir -p "${WINEPREFIX}/dosdevices/"
    ln -s "${CD_PATH}" "${WINEPREFIX}/dosdevices/${CD_DRIVE}"
    xvt.mergeRegistryTemplate "@CD_DRIVE@" "$CD_DRIVE" < "${APP_USR}/${APP_NAME}-cdrom.reg.in"
  else
    echo "No free drive letters. The CDROM will not be used." 1>&2
  fi

  # Continue
  "$@"

  # Cleanup Wine drive
  if [[ -e "$CD_DRIVE" ]]; then
    rm "${WINEPREFIX}/dosdevices/${CD_DRIVE}"
  fi
}