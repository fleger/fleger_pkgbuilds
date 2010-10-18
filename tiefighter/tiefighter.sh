# /bin/bash

sysdir="/usr/share/games/tiefighter"
usrdir="$HOME/.tiefighter"
firstRun=false

declare -A symlinks=([tie.cd]="" [imuse.exe]=tiecd)
declare -A copies=([imuse.ini]=tiecd [*.tfr]=tiecd)


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
    cp -ur "$usrdir/${copies[$f]}" "$sysdir/"$f  2> /dev/null
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
mount -t cdrom d "$sysdir"
"""

if [ "$1" = "--setup" ] || $firstRun; then
    batchScript+="""
c:
cd \\tiecd
imuse.exe
"""
fi

if [ "$1" != "--setup" ]; then
    batchScript+="""
d:
cd \\
tie.exe
"""
fi

batchScript+="exit"

dosbox -conf "$usrdir/$dosboxConfigBaseName" -c "$batchScript" -exit