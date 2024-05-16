cat <<"EOF"
 _____ _       _      _   
|  ___(_) __ _| | ___| |_ 
| |_  | |/ _` | |/ _ \ __|
|  _| | | (_| | |  __/ |_ 
|_|   |_|\__, |_|\___|\__|
         |___/            

EOF

#!/bin/zsh

read -p "Enter the text for ascii encoding: " mytext

if [ -f ~/figlet.txt ]; then
    touch ~/figlet.txt
fi

echo "cat <<\"EOF\"" > ~/figlet.txt
figlet "$mytext" >> ~/figlet.txt
echo "" >> ~/figlet.txt
echo "EOF" >> ~/figlet.txt

lines=$( cat ~/figlet.txt )
echo "$lines" | xclip -selection clipboard
xclip -sel clip ~/figlet.txt

echo "Text copied to clipboard!"
