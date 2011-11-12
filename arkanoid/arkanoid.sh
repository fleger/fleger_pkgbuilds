#! /bin/bash

if [ ! -f "/usr/lib/libarkanoid.sh" ]; then
  echo "Can't load /usr/lib/libarkanoid.sh" >&2
  exit 1
else
  . "/usr/lib/libarkanoid.sh"
fi

arkanoid.script.game() {
  local batchScript="
    mount -u c
    mount c \"$ARKANOID_MOUNTPOINT\"
    c:
    cd \\
    arkanoid.com $@
    exit
  "

  dosbox -conf "$ARKANOID_DOSBOX_CONF" -exit -c "$batchScript"
}

arkanoid.run arkanoid.script.game "$@"
