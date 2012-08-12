xvt.hooks.xvt.05-balance-of-power() {
  if xvt.firstRun || ! regedit /E /dev/null "HKEY_LOCAL_MACHINE\Software\LucasArts Entertainment Company\X-Wing vs. TIE Fighter\2.0" &> /dev/null; then
    xvt.mergeRegistryTemplate "@APP_DIR_WINE@" "${APP_DIR_WINE//\\/\\\\}" < "${APP_USR}/bop-install.reg.in"
  fi

  if [[ -n "$CD_DRIVE" ]]; then
    xvt.mergeRegistryTemplate "@CD_DRIVE@" "$CD_DRIVE" < "${APP_USR}/bop-cdrom.reg.in"
  fi

  # Continue
  "$@"
}