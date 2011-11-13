#! /bin/bash

if [ ! -f "/usr/lib/libtiefighter.sh" ]; then
  echo "Can't load /usr/lib/libtiefighter.sh" >&2
  exit 1
else
  . "/usr/lib/libtiefighter.sh"
fi

tiefighter.script.config() {
  local batchScript="
    mount -u c
    mount c \"$TF_MOUNTPOINT\"
    c:
    cd \\
    imuse.exe $@
    exit
  "
  dosbox -conf "$TF_DOSBOX_CONF" -exit -c "$batchScript"
}

tiefighter.run tiefighter.script.config "$@"
