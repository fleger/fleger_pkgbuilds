#! /bin/bash

if [ ! -f "/usr/lib/librebelassault.sh" ]; then
  echo "Can't load /usr/lib/librebelassault.sh" >&2
  exit 1
else
  . "/usr/lib/librebelassault.sh"
fi

rebelassault.script.game() {
  local batchScript="
    mount -u c
    mount c \"$RA_RW\"
    mount -u d
    mount d \"$RA_DISK\" -t cdrom
    d:
    cd \\
    rebel.exe $@
    exit
  "

  dosbox -conf "$RA_DOSBOX_CONF" -exit -c "$batchScript"
}

rebelassault.run rebelassault.script.game "$@"
