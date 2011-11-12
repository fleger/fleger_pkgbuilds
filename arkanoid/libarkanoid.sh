arkanoid.run() {
  local ARKANOID_USER_DATA="$XDG_DATA_HOME/arkanoid"
  local ARKANOID_RW="$ARKANOID_USER_DATA/rw"
  local ARKANOID_MOUNTPOINT="$ARKANOID_USER_DATA/union"
  local ARKANOID_BRANCHES_D="/etc/arkanoid.d"
  local ARKANOID_DOSBOX_CONF="$XDG_CONFIG_HOME/arkanoid/$(basename $(dosbox -printconf))"
  
  if [ ! -f "$ARKANOID_DOSBOX_CONF" ]; then
    install -Dm644 $(dosbox -printconf) "$ARKANOID_DOSBOX_CONF"
  fi

  mkdir -p "$ARKANOID_MOUNTPOINT" "$ARKANOID_RW" &&
  ARKANOID_RW="$ARKANOID_RW" modfs -o cow -o "uid=$UID" -o "gid=${GROUPS[0]}" "$ARKANOID_BRANCHES_D" "$ARKANOID_MOUNTPOINT" &&
  cd "$ARKANOID_MOUNTPOINT" &&
  "$@"

  cd /
  fusermount -u "$ARKANOID_MOUNTPOINT"
}


