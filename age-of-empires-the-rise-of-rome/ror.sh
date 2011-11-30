#! /bin/bash

if [ ! -f "/usr/lib/libaoe.sh" ]; then
  echo "Can't load /usr/lib/libaoe.sh" >&2
  exit 1
else
  . "/usr/lib/libaoe.sh"
fi

aoe.ror() {
  local __tmpReg
  # Setup registry
  if ! regedit /E /dev/null "HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft Games\Age of Empires Expansion\1.0" &> /dev/null; then
    __tmpReg="$(mktemp)" &&
    sed -e "s|@APP_DIR_WINE@|${APP_DIR_WINE//\\/\\\\\\\\}|g" "${APP_USR}/ror.reg.in" > "${__tmpReg}" &&
    regedit "${__tmpReg}" &&
    rm "${__tmpReg}"
  fi
  wine empiresx.exe "${@}"
}

aoe.run aoe.ror "${@}"
