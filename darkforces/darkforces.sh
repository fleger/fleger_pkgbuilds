# /bin/bash

shopt -s extglob

game="darkforces"
sysdir="/usr/share/games/$game"
usrdir="$HOME/.$game"
firstRun=false

declare -A symlinks=([dark/?(bootmkr.exe|dark.exe|dos4gw.exe|drive.cd|imuse.exe|install.exe|readme.txt)]="")
declare -A copies=([dark/?(imuse.ini|jedi.cfg|local.msg)]="")

if [ ! -d "$usrdir" ]; then
    mkdir -p "$usrdir"
    firstRun=true
fi

for f in "${!symlinks[@]}"; do
    mkdir -p "$usrdir/${symlinks[$f]}"
    cp -urs "$sysdir/"$f "$usrdir/${symlinks[$f]}" 2> /dev/null
done

for f in "${!copies[@]}"; do
    mkdir -p "$usrdir/${copies[$f]}"
    cp -nr "$sysdir/"$f "$usrdir/${copies[$f]}"   2> /dev/null
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

if [ "$1" = "--setup" ] || $firstRun; then
    batchScript+="""
install.exe
"""
fi

if [ "$1" != "--setup" ]; then
    batchScript+="""
dark.exe
"""
fi

batchScript+="exit"

dosbox -conf "$usrdir/$dosboxConfigBaseName" -c "$batchScript" -exit