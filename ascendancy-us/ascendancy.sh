#! /bin/bash

if [ ! -f "/usr/lib/libascendancy.sh" ]; then
  echo "Can't load /usr/lib/libascendancy.sh" >&2
  exit 1
else
  . "/usr/lib/libascendancy.sh"
fi

ascendancy.script.game() {
  local batchScript='
    mount -u c
    mount c "'"$ASCEND_MOUNTPOINT"'"
    c:
    cd \
  '
  if ascendancy.firstRun; then
    batchScript+='
      uvconfig.exe -gen
      setsound.exe
    '
  fi
  batchScript+="
    ascend.exe $@
    exit
  "

  dosbox -conf "$ASCEND_DOSBOX_CONF" -exit -c "$batchScript"
}

ascendancy.run ascendancy.script.game "$@"
