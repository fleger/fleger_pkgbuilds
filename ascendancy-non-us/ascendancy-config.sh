#! /bin/bash

if [ ! -f "/usr/lib/libascendancy.sh" ]; then
  echo "Can't load /usr/lib/libascendancy.sh" >&2
  exit 1
else
  . "/usr/lib/libascendancy.sh"
fi

ascendancy.script.config() {
  local batchScript='
    mount -u c
    mount c "'"$ASCEND_MOUNTPOINT"'"
    c:
    cd \
    uvconfig -gen
    setsound
    exit
  '
  dosbox -conf "$ASCEND_DOSBOX_CONF" -exit -c "$batchScript"
}

ascendancy.run ascendancy.script.config "$@"
