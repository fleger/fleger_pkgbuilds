darkforces.run() {
  local DF_USER_DATA="$XDG_DATA_HOME/darkforces"
  local DF_RW="$DF_USER_DATA/rw"
  local DF_MOUNTPOINT="$DF_USER_DATA/union"
  local DF_BRANCHES_D="/etc/darkforces.d"
  local DF_DOSBOX_CONF="$XDG_CONFIG_HOME/darkforces/$(basename $(dosbox -printconf))"
  
  local __dfFirstRun=true

  if [ ! -f "$DF_DOSBOX_CONF" ]; then
    install -Dm644 $(dosbox -printconf) "$DF_DOSBOX_CONF"
  fi
  
  if [ -d "$DF_MOUNTPOINT" ]; then
    __dfFirstRun=false
  fi

  mkdir -p "$DF_MOUNTPOINT" "$DF_RW" &&
  DF_RW="$DF_RW" modfs -o cow -o "uid=$UID" -o "gid=${GROUPS[0]}" "$DF_BRANCHES_D" "$DF_MOUNTPOINT" &&
  cd "$DF_MOUNTPOINT" &&
  "$@"

  cd /
  fusermount -u "$DF_MOUNTPOINT"
}

darkforces.firstRun() {
  "$__dfFirstRun"
}


