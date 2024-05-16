cat <<"EOF"
         _                _               
 _______| |__    ___  ___| |_ _   _ _ __  
|_  / __| '_ \  / __|/ _ \ __| | | | '_ \ 
 / /\__ \ | | | \__ \  __/ |_| |_| | |_) |
/___|___/_| |_| |___/\___|\__|\__,_| .__/ 
                                   |_|    

EOF

echo "removing any existing zsh config"
rm -rf ~/.oh-my-zsh
rm ~/.zshrc

echo "installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "installing zsh pluggins"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/zsh-syntax-highlighting






echo "installing firefox theme"
curl -s -o- https://raw.githubusercontent.com/rafaelmardojai/firefox-gnome-theme/master/scripts/install-by-curl.sh | bash

echo "installing bun"
curl -fsSL https://bun.sh/install | bash

echo "installing rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo "installing solana"
sh -c "$(curl -sSfL https://release.solana.com/stable/install)"

echo "installing ollama"
curl -fsSL https://ollama.com/install.sh | sh

echo "installing nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

echo "installing lts node"
nvm install --lts

