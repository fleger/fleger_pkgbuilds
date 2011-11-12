ascendancy.run() {
  local ASCEND_USER_DATA="$XDG_DATA_HOME/ascendancy"
  local ASCEND_RW="$ASCEND_USER_DATA/rw"
  local ASCEND_MOUNTPOINT="$ASCEND_USER_DATA/union"
  local ASCEND_BRANCHES_D="/etc/ascendancy.d"
  local ASCEND_DOSBOX_CONF="$XDG_CONFIG_HOME/ascendancy/$(basename $(dosbox -printconf))"
  
  if [ ! -f "$ASCEND_DOSBOX_CONF" ]; then
    install -Dm644 $(dosbox -printconf) "$ASCEND_DOSBOX_CONF"
  fi

  mkdir -p "$ASCEND_MOUNTPOINT" "$ASCEND_RW" &&
  ASCEND_RW="$ASCEND_RW" modfs -o cow -o "uid=$UID" -o "gid=${GROUPS[0]}" "$ASCEND_BRANCHES_D" "$ASCEND_MOUNTPOINT" &&
  cd "$ASCEND_MOUNTPOINT" &&
  "$@"

  cd /
  fusermount -u "$ASCEND_MOUNTPOINT"
}

ascendancy.firstRun() {
  [ ! -f "$ASCEND_RW/UNIVBE.DRV" ] && [ ! -f "$ASCEND_RW/univbe.drv" ]
}


