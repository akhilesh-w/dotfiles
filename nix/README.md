# dopamine's Nix Configuration

This directory contains a reproducible NixOS/Home Manager configuration, migrated from my Arch Linux dotfiles.

## 📁 Structure

```
nix/
├── flake.nix           # Entry point - defines inputs and outputs
├── home.nix            # Home Manager config (packages, dotfiles, programs)
└── nixos/
    └── configuration.nix   # NixOS system config (for full NixOS install)
```

## 🚀 Usage Options

### Option 1: Standalone Home Manager on Arch Linux

You can use Home Manager on your current Arch system to manage your dotfiles and user packages:

```bash
# Install Nix (if not already installed)
sh <(curl -L https://nixos.org/nix/install) --daemon

# Enable flakes
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# Apply Home Manager configuration
cd ~/dotfiles/nix
nix run home-manager -- switch --flake .#dopamine
```

### Option 2: Full NixOS Installation

For a complete NixOS system:

1. Boot into the NixOS installer
2. Generate hardware configuration:
   ```bash
   sudo nixos-generate-config --root /mnt
   cp /mnt/etc/nixos/hardware-configuration.nix ~/dotfiles/nix/nixos/
   ```
3. Apply the configuration:
   ```bash
   sudo nixos-rebuild switch --flake ~/dotfiles/nix#dopamine
   ```

## 📦 What's Included

### Shell & Terminal
- **zsh** with oh-my-zsh, autosuggestions, and syntax highlighting
- **kitty** and **alacritty** terminals
- **tmux** with all your keybindings

### CLI Tools
- `eza` (modern ls), `bat` (better cat), `ripgrep`, `fd`, `fzf`, `zoxide`
- `yt-dlp`, `neofetch`, `btop`

### Window Managers
- **Hyprland** (Wayland) - primary
- **i3** config preserved
- **rofi** (app launcher)
- **waybar** (status bar)
- **dunst** (notifications)
- **picom** (X11 compositor)

### Development
- `git`, `neovim`, `gcc`, `nodejs`, `bun`, `rustup`, `go`, `python3`

### Fonts
- JetBrains Mono Nerd Font
- FiraCode Nerd Font
- Hack Nerd Font

## 🔄 Updating

```bash
# Update flake inputs
cd ~/dotfiles/nix
nix flake update

# Apply changes (Home Manager)
home-manager switch --flake .#dopamine

# Apply changes (NixOS)
sudo nixos-rebuild switch --flake .#dopamine
```

## 📝 Customizing

- Edit `home.nix` to add/remove packages or modify program configs
- Edit `nixos/configuration.nix` for system-level changes
- Run the appropriate switch command after making changes

## 🔗 Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.html)
- [Nix Pills](https://nixos.org/guides/nix-pills/) - Learn Nix language
- [Hyprland Wiki](https://wiki.hyprland.org/)
