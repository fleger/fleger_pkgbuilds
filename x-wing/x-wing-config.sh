#! /bin/bash

if [ ! -f "/usr/lib/libx-wing.sh" ]; then
  echo "Can't load /usr/lib/libx-wing.sh" >&2
  exit 1
else
  . "/usr/lib/libx-wing.sh"
fi

x-wing.script.config() {
  local batchScript="
    mount -u c
    mount c \"$XW_MOUNTPOINT\"
    c:
    cd \\
    install.exe $@
    exit
  "
  dosbox -conf "$XW_DOSBOX_CONF" -exit -c "$batchScript"
}

x-wing.run x-wing.script.config "$@"
