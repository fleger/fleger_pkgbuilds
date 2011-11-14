rebelassault.run() {
  local RA_RW="$XDG_DATA_HOME/rebelassault"
  local RA_DOSBOX_CONF="$XDG_CONFIG_HOME/rebelassault/$(basename $(dosbox -printconf))"
  local RA_DISK="/usr/share/games/rebelassault"

  if [ ! -f "$RA_DOSBOX_CONF" ]; then
    install -Dm644 $(dosbox -printconf) "$RA_DOSBOX_CONF"
  fi

  mkdir -p "$RA_RW" &&
  cd "$RA_RW" &&
  "$@"
}

rebelassault.firstRun() {
  [ ! -f "$RA_RW/REBEL/REB.BAT" ]
}


