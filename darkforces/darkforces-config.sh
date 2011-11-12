#! /bin/bash

if [ ! -f "/usr/lib/libdarkforces.sh" ]; then
  echo "Can't load /usr/lib/libdarkforces.sh" >&2
  exit 1
else
  . "/usr/lib/libdarkforces.sh"
fi

darkforces.script.config() {
  local batchScript="
    mount -u c
    mount c \"$DF_MOUNTPOINT\"
    c:
    cd \\
    rename cd.id cd.bak
    cd \\dark
    install.exe $@
    cd \\
    rename cd.bak cd.id
    exit
  "
  dosbox -conf "$DF_DOSBOX_CONF" -exit -c "$batchScript"
}

darkforces.run darkforces.script.config "$@"
