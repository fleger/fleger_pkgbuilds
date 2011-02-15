#! /bin/bash

shopt -s extglob

## Begin configuration

game="arkanoid"

# Where the game files are installed
sysdir="/usr/share/games/$game"

# Where the user's game directory will be
usrdir="$HOME/.$game"

# List of files that should be symlinked. Syntax: [file1 file2...]="installation subdirectory"
declare -A symlinks=([arkanoid.?(com|pgm)]="")

# List of files that should be copied (writable files like scores, configuration...)
declare -A copies=([arkanoid.scr]="")

# Batch scripts executed by DOSBox

# Always executed at the beginning
beginScript=""

# Executed only if this is the first time the program is started
firstRunScript=""

# Executed only if this is *not* the first time the program is started
notFirstRunScript=""

# Always executed at the end
endScript="""
mount -u c
mount c "$usrdir"
c:
cd \\
arkanoid.com
"""

## End configuration

# Test if this is the first time the program is started
firstRun=false
if [ ! -d "$usrdir" ]; then
  mkdir -p "$usrdir"
  firstRun=true
fi

# Create / update symlinks
for f in "${!symlinks[@]}"; do
  mkdir -p "$usrdir/${symlinks[$f]}"
  cp -urs "$sysdir/"$f "$usrdir/${symlinks[$f]}" 2> /dev/null
done

# Copy files
for f in "${!copies[@]}"; do
  mkdir -p "$usrdir/${copies[$f]}"
  cp -nr "$sysdir/"$f "$usrdir/${copies[$f]}"   2> /dev/null
done

# Copy the general DOSBox configuration file to $usrdir
dosboxMainConfig="$(dosbox -printconf)"
dosboxConfigBaseName="""$(basename "$dosboxMainConfig")"""

if [ ! -e "$usrdir/$dosboxConfigBaseName" ]; then
  cp "$dosboxMainConfig" "$usrdir/$dosboxConfigBaseName"
fi

# Build the batch script that will be executed in the DOSBox
batchScript="$beginScript"

if firstRun; then
  batchScript+="$firstRunScript"
else
  batchScript+="$notFirstRunScript"
fi

batchScript+="$endScript"

# Exit the DOSBox after the program is finished
batchScript+="exit"

# Start the DOSBox
dosbox -conf "$usrdir/$dosboxConfigBaseName" -c "$batchScript" -exit
