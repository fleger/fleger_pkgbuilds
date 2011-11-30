#! /bin/bash

_readCString() {
  local string=""
  local byte=""
  local returnCode=0
  until [ "x${byte## }" = 'x\0' ] || [ "x${returnCode}" != "x0" ]; do
    string+="${byte## }"
    read -r byte
    returnCode="$?"
  done

  echo -n "${string}"

  return "${returnCode}"
}

_extractTable() {
  local -r STATE_MAGIC=0
  local -r STATE_LENGTH=1
  local -r STATE_SOURCE=2
  local -r STATE_DEST=3
  local -r STATE_JUNK=4
  local -r STATE_END=5
  local -r STATE_ERROR=-1
  
  local state="${STATE_MAGIC}"
  local byte
  local i
  local key

  while [ "x${state}" != "x${STATE_END}" ] && [ "x${state}" != "x${STATE_ERROR}" ]; do
    case "${state}" in
      "${STATE_MAGIC}")
        read -r byte &&
        [ "x${byte## }" = "x${MAGIC_CHARS[0]}" ] &&
        read -r byte &&
        [ "x${byte## }" = "x${MAGIC_CHARS[1]}" ] &&
        state="${STATE_LENGTH}" ||
        state="${STATE_END}"
        ;;
      "${STATE_LENGTH}")
        read -r byte &&
        read -r byte &&
        state="${STATE_SOURCE}" ||
        state="${STATE_END}"
        ;;
      "${STATE_SOURCE}")
        key=$(_readCString) &&
        key="${key,,*}" &&
        state="${STATE_DEST}" ||
        state="${STATE_ERROR}"
        ;;
      "${STATE_DEST}")
        i=$(_readCString) &&
        i="${i##*\\}" && {
          [[ "${i}" =~ ^%STRING([0-9]+)$ ]] &&
          fileTable["${key##*\\}"]=$((${BASH_REMATCH[1]} + ${STRING_ID_OFFSET})) ||
          true
        } &&
        state="${STATE_JUNK}" ||
        state="${STATE_ERROR}"
        ;;
      "${STATE_JUNK}")
        for i in $(seq 1 ${JUNK_LENGTH}); do
          read -r byte
        done &&
        state="${STATE_MAGIC}" ||
        state="${STATE_END}"
        ;;
    esac
  done < <(od -An -j"${START_OFFSET}" -tc -v -w1 "$1")
  [ "x${state}" = "x$STATE_END" ] &&
  return 0 ||
  return 1
}

_parseStringTable() {
  local -a offSets
  local -A lengths
  local l
  local next=0
  local c=0
  while read l; do
    if [ "$c" = "$next" ]; then
      offSets+=($(($c * 2 + 2)))
      lengths[$(($c * 2 + 2))]=$l
      next=$(($c + $l + 1))
    fi
    c=$(($c + 1))
  done < <(od -An -t u2 -w2 -v "$1")
  for c in "${offSets[@]}"; do
    l=$(tail -c +"$c" "$1" | head -c "$((${lengths[$c]} * 2))" | iconv -f "utf16be")
    [ -n "${l}" ] && stringTable+=("${l##*\\}") || true
  done
}

_extractStringTables() {
  local i
  for i in $(seq "${STRING_RANGE[@]}"); do
    wrestool --type=6 --name="$i" -x --raw "$1"
  done
}


_tr() {
  local b=$(basename "${1}")
  local d=$(dirname "${1}")
  [ -n "${fileTable[${b,,*}]}" ] &&
  echo "${d}/${stringTable[${fileTable[${b,,*}]}]}" ||
  echo "${1,,*}"
}

_init() {
  if [ -f "${CD_DIR}/setupexp.dll" ]; then
    # Standalone ROR Expansion
    SETUP_DLL="setupexp.dll"
    STRING_RANGE=(38 47)
    SETUP_BINARY_TYPE="SETUPBINARY"
    START_OFFSET=$((0xA3))
    MAGIC_CHARS=($'\x50' '\0')
    JUNK_LENGTH=36
    STRING_ID_OFFSET=-100
  elif [ -d "${CD_DIR}/game/data2" ]; then
    # Gold Edition
    SETUP_DLL="setupenu.dll"
    STRING_RANGE=(38 52)
    SETUP_BINARY_TYPE="SETUPBINARY"
    START_OFFSET=$((0x110))
    MAGIC_CHARS=($'\x50' '\0')
    JUNK_LENGTH=36
    STRING_ID_OFFSET=-100
  else
    # Standard AOE Edition
    SETUP_DLL="setupenu.dll"
    STRING_RANGE=(33 39)
    SETUP_BINARY_TYPE="COMMANDDATA"
    START_OFFSET=$((0x258))
    MAGIC_CHARS=('240' '\0')
    JUNK_LENGTH=30
    STRING_ID_OFFSET=-12
  fi
  SETUP_EXE="$(sed -n -r -e 's/^open=([A-Za-z0-9.]+).*$/\1/pI' "$(find "${CD_DIR}" -maxdepth 1 -iname "autorun.inf" -print)")"
}

local SETUP_DLL
local -a STRING_RANGE
local SETUP_BINARY_TYPE
local START_OFFSET
local MAGIC_CHARS
local JUNK_LENGTH
local STRING_ID_OFFSET
local SETUP_EXE
local -a stringTable
local -A fileTable

_init
_extractStringTables "$(find "${CD_DIR}" -maxdepth 1 -iname "${SETUP_DLL}" -print)" > "${srcdir}/stringTable"
_parseStringTable "${srcdir}/stringTable"
wrestool -x --type="${SETUP_BINARY_TYPE}" --raw "$(find "${CD_DIR}" -maxdepth 1 -iname "${SETUP_EXE}" -print)" > "${srcdir}/fileTable"
_extractTable "${srcdir}/fileTable"