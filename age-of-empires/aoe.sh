#! /bin/bash

if [ ! -f "/usr/lib/libaoe.sh" ]; then
  echo "Can't load /usr/lib/libaoe.sh" >&2
  exit 1
else
  . "/usr/lib/libaoe.sh"
fi

aoe.run wine empires.exe "$@"
