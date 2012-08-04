#! /bin/bash

if [ ! -f "/usr/lib/libswkotor2.sh" ]; then
  echo "Can't load /usr/lib/libswkotor2.sh" >&2
  exit 1
else
  . "/usr/lib/libswkotor2.sh"
fi

readonly SCRIPT_NAME="${0}"

swkotor2.script.config() {
  wine swconfig.exe "$@"
}

swkotor2.run swkotor2.script.config "$@"
