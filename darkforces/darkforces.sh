# /bin/bash

sysdir="/usr/share/games/darkforces"
usrdir="$HOME/.darkforces"

symlinks=(bootmkr.exe dark.exe dos4gw.exe drive.cd imuse.exe install.exe readme.txt)
copies=(imuse.ini jedi.cfg local.msg)

if [ ! -d "$usrdir" ]; then
    mkdir -p "$usrdir"
fi

for f in "${symlinks[@]}"; do
    cp -urs "$sysdir/dark/$f" "$usrdir" 2> /dev/null
done

for f in "${copies[@]}"; do
    cp -ur "$sysdir/dark/$f" "$usrdir" 2> /dev/null
done

dosboxMainConfig="$(dosbox -printconf)"
dosboxConfigBaseName="""$(basename "$dosboxMainConfig")"""

if [ ! -e "$usrdir/$dosboxConfigBaseName" ]; then
    cp "$dosboxMainConfig" "$usrdir/$dosboxConfigBaseName"
fi

batchScript="""
mount -u c
mount -u d
mount c "$usrdir"
mount d "$sysdir"
c:
cd \
"""

if [ "$1" = "--setup" ]; then
    batchScript+="""
install.exe
"""
elif [ ! -f "$usrdir/DARKPILO.CFG" ]; then
    batchScript+="""
install.exe
dark.exe
"""
else
    batchScript+="""
dark.exe
"""
fi

batchScript+="exit"

dosbox -conf "$usrdir/$dosboxConfigBaseName" -c "$batchScript" -exit