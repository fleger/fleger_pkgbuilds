nwn.hooks.nwn.20-nwmouse() {
  XCURSOR_PATH="$PWD" XCURSOR_THEME="nwmouse" LD_PRELOAD="./nwmouse/nwmouse.so:${LD_PRELOAD}" "${@}"
}

nwn.hooks.dmclient.20-nwmouse() {
  XCURSOR_PATH="$PWD" XCURSOR_THEME="nwmouse" LD_PRELOAD="./nwmouse/nwmouse.so:${LD_PRELOAD}" "${@}"
}
