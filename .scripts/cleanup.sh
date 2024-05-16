#!/bin/zsh
clear
cat <<"EOF"
  ____ _                                
 / ___| | ___  __ _ _ __    _   _ _ __  
| |   | |/ _ \/ _` | '_ \  | | | | '_ \ 
| |___| |  __/ (_| | | | | | |_| | |_) |
 \____|_|\___|\__,_|_| |_|  \__,_| .__/ 
                                 |_|    

EOF

sudo pacman -Rns $(pacman -Qtdq)

yay -Scc


# This script is used to remove packages that were installed from sources other than the official Arch Linux repository and cleaning up unnecessary files using yay.
