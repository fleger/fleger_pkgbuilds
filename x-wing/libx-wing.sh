x-wing.run() {
  local XW_USER_DATA="$XDG_DATA_HOME/x-wing"
  local XW_RW="$XW_USER_DATA/rw"
  local XW_MOUNTPOINT="$XW_USER_DATA/union"
  local XW_BRANCHES_D="/etc/x-wing.d"
  local XW_DOSBOX_CONF="$XDG_CONFIG_HOME/x-wing/$(basename $(dosbox -printconf))"
  local XW_DISK="/usr/share/games/x-wing/data"

  local __xwFirstRun=true

  if [ ! -f "$XW_DOSBOX_CONF" ]; then
    install -Dm644 $(dosbox -printconf) "$XW_DOSBOX_CONF"
  fi

  if [ -d "$XW_MOUNTPOINT" ]; then
    __xwFirstRun=false
  fi

  mkdir -p "$XW_MOUNTPOINT" "$XW_RW" &&
  XW_RW="$XW_RW" modfs -o cow -o "uid=$UID" -o "gid=${GROUPS[0]}" "$XW_BRANCHES_D" "$XW_MOUNTPOINT" &&
  cd "$XW_MOUNTPOINT" &&
  "$@"

  cd /
  fusermount -u "$XW_MOUNTPOINT"
}

x-wing.firstRun() {
  "$__xwFirstRun"
}


