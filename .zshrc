# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"
# ZSH_THEME="powerlevel10k/powerlevel10k"

# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

 zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# rust 
. "$HOME/.cargo/env"

# solana 
export PATH="/home/dopamine/.local/share/solana/install/active_release/bin:$PATH"

# aliases 
# better navigation
alias config='cd ~/.config'
alias battery='cd /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00; code .'
alias zshconfig='nvim ~/.zshrc'
alias ohmyzsh='nvim ~/.oh-my-zsh'
alias :q='exit'
alias e='exit'

alias path='echo -e ${PATH//:/\\n}' # prints path environmental variable
alias install='sudo pacman -S'
alias plz='sudo $(fc -ln -1)'
alias tree='exa --tree'
# alias uptime='uptime --pretty'
alias free='free -h'
alias ytdl='yt-dlp'
alias ytdlm='yt-dlp --extract-audio --audio-format mp3'

# ls 
alias ls='exa'
alias li='exa --icons'
alias ll='exa -a'
alias lli='exa -a --icons'
alias l='exa -lh'
alias la='exa -alh'
alias lai='exa -alh --icons'
alias llt="exa -1 --icons --tree --git-ignore"

# git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gcl='git clone'
alias gi='git init'
alias gpl='git pull'
alias gco='git checkout'

# tmux aliases
alias t='tmux'
alias tl='tmux ls'
alias ta='tmux attach-session -t '
alias tn='tmux new-session -s'
alias tk='tmux kill-session -t'

# pacman
alias p='pacman'
alias sp='sudo pacman'
alias psi='pacman -Si'
alias i='sudo pacman -S'
alias aheka='pacman -Qi'

# fzf alias 
alias search="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' | xargs nvim"

# xorg-xgamma 
alias g10='xgamma -q -gamma 1.0'
alias g11='xgamma -q -gamma 1.1'
alias g12='xgamma -q -gamma 1.2'
alias g13='xgamma -q -gamma 1.3'
alias g14='xgamma -q -gamma 1.4'
alias g15='xgamma -q -gamma 1.5'
alias g5='xgamma -q -gamma 0.5'
alias g75='xgamma -q -gamma 0.75'

# system 
alias off='sudo shutdown now'
alias restart='sudo shutdown -r now'
alias suspend='systemctl suspend'

# zoxide - cd alternative
eval "$(zoxide init zsh)"

# nvm 
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# bun completions
[ -s "/home/dopamine/.bun/_bun" ] && source "/home/dopamine/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# starship prompt
#eval "$(starship init zsh)"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
