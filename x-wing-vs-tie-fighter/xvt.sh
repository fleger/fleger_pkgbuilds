#! /bin/bash

if [ ! -f "/usr/lib/libxvt.sh" ]; then
  echo "Can't load /usr/lib/libxvt.sh" >&2
  exit 1
else
  . "/usr/lib/libxvt.sh"
fi

xvt.run xvt.hooks xvt wine z_xvt__.exe "$@"
