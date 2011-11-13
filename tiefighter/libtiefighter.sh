tiefighter.run() {
  local TF_USER_DATA="$XDG_DATA_HOME/tiefighter"
  local TF_RW="$TF_USER_DATA/rw"
  local TF_MOUNTPOINT="$TF_USER_DATA/union"
  local TF_BRANCHES_D="/etc/tiefighter.d"
  local TF_DOSBOX_CONF="$XDG_CONFIG_HOME/tiefighter/$(basename $(dosbox -printconf))"
  local TF_DISK="/usr/share/games/tiefighter/disk"

  local __tfFirstRun=true

  if [ ! -f "$TF_DOSBOX_CONF" ]; then
    install -Dm644 $(dosbox -printconf) "$TF_DOSBOX_CONF"
  fi

  if [ -d "$TF_MOUNTPOINT" ]; then
    __tfFirstRun=false
  fi

  mkdir -p "$TF_MOUNTPOINT" "$TF_RW" &&
  TF_RW="$TF_RW" modfs -o cow -o "uid=$UID" -o "gid=${GROUPS[0]}" "$TF_BRANCHES_D" "$TF_MOUNTPOINT" &&
  cd "$TF_MOUNTPOINT" &&
  "$@"

  cd /
  fusermount -u "$TF_MOUNTPOINT"
}

tiefighter.firstRun() {
  "$__tfFirstRun"
}


