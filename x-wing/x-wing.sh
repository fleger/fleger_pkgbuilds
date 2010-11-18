#! /bin/bash

shopt -s extglob

game="x-wing"
sysdir="/usr/share/games/$game"
usrdir="$HOME/.$game"
firstRun=false

declare -A symlinks=([!(topace5.plt|setmuse.ini|landru.cfg|options.cfg)]="xwingcd")
declare -A copies=([topace5.plt setmuse.ini landru.cfg options.cfg]="xwingcd")


if [ ! -d "$usrdir" ]; then
    mkdir -p "$usrdir"
    firstRun=true
fi

cd "$sysdir"

for f in "${!symlinks[@]}"; do
    mkdir -p "$usrdir/${symlinks[$f]}"
    cp -urs "$sysdir/"$f "$usrdir/${symlinks[$f]}" #2> /dev/null
done

for f in "${!copies[@]}"; do
    mkdir -p "$usrdir/${copies[$f]}"
    cp -nr $f "$usrdir/${copies[$f]}"   #2> /dev/null
done

dosboxMainConfig="$(dosbox -printconf)"
dosboxConfigBaseName="""$(basename "$dosboxMainConfig")"""

if [ ! -e "$usrdir/$dosboxConfigBaseName" ]; then
    cp "$dosboxMainConfig" "$usrdir/$dosboxConfigBaseName"
fi

batchScript="""
mount -u c
mount -u d
mount -t cdrom d "$sysdir"
mount c "$usrdir"
"""

if [ "$1" = "--setup" ] || $firstRun; then
    batchScript+="""
c:
cd \\xwingcd
install.exe
"""
fi

if [ "$1" != "--setup" ]; then
    batchScript+="""
c:
cd \\xwingcd
bwing.exe
"""
fi

batchScript+="exit"

dosbox -conf "$usrdir/$dosboxConfigBaseName" -c "$batchScript" -exit