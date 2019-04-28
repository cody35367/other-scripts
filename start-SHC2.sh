#!/bin/bash

SHC2_PROTON_PATH=~/.steam/steam/steamapps/common/Proton\ 3.7/proton
SHC2_EXE_PATH=~/snap/gog-galaxy-wine/common/.wine/drive_c/Program\ Files\ \(x86\)/GOG\ Galaxy/Games/Stronghold\ Crusader\ 2/bin/win32_galaxy_release/Crusader2.exe

export LD_LIBRARY_PATH=~/.local/share/Steam/ubuntu12_32/:\
~/.local/share/Steam/ubuntu12_32/steam-runtime/i386/lib/i386-linux-gnu/:\
~/.local/share/Steam/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/:\
~/.local/share/Steam/ubuntu12_32/steam-runtime/amd64/lib/x86_64-linux-gnu/:\
~/.local/share/Steam/ubuntu12_32/steam-runtime/amd64/usr/lib/x86_64-linux-gnu/:\
$LD_LIBRARY_PATH

export STEAM_COMPAT_DATA_PATH=~/.proton/SHC2 
export PROTON_NO_ESYNC=1 

"$SHC2_PROTON_PATH" run "$SHC2_EXE_PATH"