#! /bin/bash

if [ ! -f "/usr/lib/libdune.sh" ]; then
  echo "Can't load /usr/lib/libdune.sh" >&2
  exit 1
else
  . "/usr/lib/libdune.sh"
fi

readonly SCRIPT_NAME="${0}"

dune.script.config() {
  local batchScript='
    mount -u d
    mount -t cdrom d "'"${APP_DISK}"'"
    mount -u c
    mount c "'"${APP_DIR}"'"
    d:
    cd \
    install.exe '"$@"'
    exit
  '
  SDL_VIDEO_X11_WMCLASS=$(basename "${SCRIPT_NAME%.*}") dosbox -conf "${DOSBOX_CONF}" -exit -c "${batchScript}"
}

dune.run dune.script.config "$@"
