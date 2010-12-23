# /bin/bash

shopt -s extglob

game="arkanoid"
sysdir="/usr/share/games/$game"
usrdir="$HOME/.$game"
firstRun=false

declare -A symlinks=([arkanoid.?(com|pgm)]="")
declare -A copies=([arkanoid.scr]="")

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
mount c "$usrdir"
c:
cd \\
arkanoid.com
"""

batchScript+="exit"

dosbox -conf "$usrdir/$dosboxConfigBaseName" -c "$batchScript" -exit