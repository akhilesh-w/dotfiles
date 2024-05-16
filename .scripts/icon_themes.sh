cat << "EOF"
 _                    _   _
(_) ___ ___  _ __    | |_| |__   ___ _ __ ___   ___  ___
| |/ __/ _ \| '_ \   | __| '_ \ / _ \ '_ ` _ \ / _ \/ __|
| | (_| (_) | | | |  | |_| | | |  __/ | | | | |  __/\__ \
|_|\___\___/|_| |_|___\__|_| |_|\___|_| |_| |_|\___||___/
                 |_____|

EOF

#!/bin/zsh

# Set the directory where you want to clone the repositories
base_dir="/home/dopamine/Downloads"

# Clone and install Colloid icon theme
cd "$base_dir"
git clone https://github.com/vinceliuice/Colloid-icon-theme.git
cd Colloid-icon-theme
./install.sh -s all
cd "$base_dir"

# Clone and install Orchis theme
cd "$base_dir"
git clone https://github.com/vinceliuice/Orchis-theme.git
cd Orchis-theme
./install.sh --tweaks black -t all
cd "$base_dir"
