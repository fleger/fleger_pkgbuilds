#! /bin/bash

if [ ! -f "/usr/lib/libtiefighter.sh" ]; then
  echo "Can't load /usr/lib/libtiefighter.sh" >&2
  exit 1
else
  . "/usr/lib/libtiefighter.sh"
fi

tiefighter.script.game() {
  local batchScript='
    mount -u c
    mount c "'"$TF_MOUNTPOINT"'"
    mount -u d
    mount d "'"$TF_DISK"'" -t cdrom
  '
  if tiefighter.firstRun; then
    batchScript+='
      c:
      cd \
      imuse.exe
    '
  fi
  batchScript+="
    d:
    cd \\
    tie.exe $@
    exit
  "

  dosbox -conf "$TF_DOSBOX_CONF" -exit -c "$batchScript"
}

tiefighter.run tiefighter.script.game "$@"
