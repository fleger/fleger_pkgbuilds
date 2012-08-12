xvt.run() {
  local -r APP_NAME="xvt"
  local -r APP_USR="/usr/share/games/xvt"
  local -r TMPDIR="${TMPDIR:-/tmp}"
  local RW_BRANCH="${XDG_DATA_HOME:-${HOME}/.local/share}/${APP_NAME}"
  local -r CONF_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/${APP_NAME}"
  local -r APP_DIR="${TMPDIR}/${APP_NAME}-tmp-${USER}"
  local -r BRANCHES_D="/etc/${APP_NAME}/branches.d"

  local __firstRun=false
  if [[ ! -d "${RW_BRANCH}" ]]; then
    __firstRun=true
  fi

  # Mount the union
  mkdir -p "${RW_BRANCH}" "${APP_DIR}"
  RW_BRANCH="${RW_BRANCH}" modfs -o cow -o "uid=${UID}" -o "gid=${GROUPS[0]}" "${BRANCHES_D}" "${APP_DIR}"

  # Run the application
  cd "${APP_DIR}"
  "$@"

  # Unmount the union
  cd /
  fusermount -u "${APP_DIR}"
  rmdir "${APP_DIR}"
}

xvt.firstRun() {
  $__firstRun
}

xvt.mergeRegistryTemplate() {
  local -A expressions=()
  while [[ $# -ge 2 ]]; do
    expressions["$1"]="$2"
    shift 2
  done
  local tmpReg="$(mktemp)"
  local line
  local key
  local value
  while IFS= read -r line; do
    for key in "${!expressions[@]}"; do
      value="${expressions["$key"]}"
      line="${line//$key/$value}"
    done
    echo "$line"
  done > "$tmpReg"
  regedit "$tmpReg"
  rm "$tmpReg"
}

xvt.hooks() {
  local -r EXEC_NAME="${1}"
  shift
  local -ar HOOKS_D=("/etc/${APP_NAME}/hooks.d" "$CONF_DIR/hooks.d")
  local -r HOOKS_PREFIX="$APP_NAME.hooks.${EXEC_NAME}."
  local hooksD
  for hooksD in "${HOOKS_D[@]}"; do
    if [ -d "${hooksD}" ]; then
      local f
      for f in "${hooksD}/"*.sh; do
        [ -f "${f}" ] && source "${f}"
      done
    fi
  done
  local -a commandLine=($(compgen -A function "${HOOKS_PREFIX}") "${@}")
  "${commandLine[@]}"
}