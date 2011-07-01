#! /bin/bash

export SWKOTOR_USER_DATA="$XDG_DATA_HOME/swkotor"
SWKOTOR_MOUNTPOINT="$SWKOTOR_USER_DATA/union"
SWKOTOR_BRANCHES_D="/etc/swkotor.d"

mkdir -p "$SWKOTOR_MOUNTPOINT" "$SWKOTOR_USER_DATA/union" &&
modfs -o cow -o "uid=$UID" -o "gid=${GROUPS[0]}" "$SWKOTOR_BRANCHES_D" "$SWKOTOR_MOUNTPOINT" &&
cd "$SWKOTOR_MOUNTPOINT" &&
wine swkotor.exe "$@"
cd ..
fusermount -u "$SWKOTOR_MOUNTPOINT"


