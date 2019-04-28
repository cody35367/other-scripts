#!/bin/bash
b_filename=save-backup-$(date +%Y%m%d-%H%M%S).tar.gz
b_dest=~/important/gaming/MonsterHunterWorld/
b_source_base=~/.local/share/Steam/userdata/68725788/582010/remote
cd $b_source_base
tar -czvf $b_dest$b_filename $(find . -type f) 