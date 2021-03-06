#! /bin/bash

if [ ! -f "/usr/lib/libswkotor.sh" ]; then
  echo "Can't load /usr/lib/libswkotor.sh" >&2
  exit 1
else
  . "/usr/lib/libswkotor.sh"
fi

readonly SCRIPT_NAME="${0}"

swkotor.script.game() {
  wine swkotor.exe "$@"
}

swkotor.run swkotor.script.game "$@"
