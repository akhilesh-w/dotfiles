{ config, pkgs, inputs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "dopamine";
  home.homeDirectory = "/home/dopamine";

  # This value determines the Home Manager release compatibility
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # ============================================================================
  # PACKAGES
  # ============================================================================
  
  home.packages = with pkgs; [
    # === Terminal & Shell ===
    kitty
    alacritty
    tmux
    zsh
    oh-my-zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    starship
    
    # === CLI Tools ===
    eza                   # modern ls (was exa)
    bat                   # better cat
    ripgrep               # better grep
    fd                    # better find
    fzf                   # fuzzy finder
    zoxide                # smarter cd
    btop                  # system monitor
    neofetch              # system info
    fastfetch             # faster neofetch alternative
    tree
    jq                    # JSON processor
    tldr                  # simplified man pages
    w3m                   # terminal web browser
    ttyper                # typing practice
    genact                # fake activity generator
    progress              # show progress of coreutils
    stow                  # symlink manager
    
    # === File Management ===
    yazi                  # terminal file manager
    
    # === Media ===
    yt-dlp                # youtube downloader
    mpv                   # video player
    vlc                   # VLC media player
    mpd                   # music player daemon
    mplayer               # media player
    cmus                  # terminal music player
    cheese                # webcam app
    obs-studio            # streaming/recording
    
    # === Image Tools ===
    feh                   # image viewer
    sxiv                  # simple X image viewer
    gimp                  # image editor
    gpick                 # color picker
    
    # === Video & 3D ===
    blender               # 3D creation suite
    
    # === Development ===
    git
    neovim
    neovide               # neovim GUI
    gcc
    gnumake
    nodejs_20
    bun
    rustup
    go
    python3
    
    # === Window Manager & Desktop ===
    rofi-wayland
    waybar
    dunst
    picom
    playerctl             # media player control
    variety               # wallpaper manager
    
    # === System Utilities ===
    gparted               # partition editor
    pavucontrol           # audio control
    networkmanagerapplet  # network manager tray
    brightnessctl         # brightness control
    powertop              # power management
    nvtop                 # NVIDIA GPU monitor
    
    # === Screenshots ===
    maim                  # X11 screenshot
    flameshot             # feature-rich screenshot
    grim                  # screenshot (Wayland)
    slurp                 # screen selection (Wayland)
    scrot                 # screenshot (X11)
    
    # === Clipboard ===
    xclip                 # clipboard (X11)
    wl-clipboard          # clipboard (Wayland)
    clipmenu              # clipboard manager
    
    # === Screen & Display ===
    redshift              # screen temperature (X11)
    gammastep             # screen temperature (Wayland)
    xorg.xgamma           # gamma control
    xss-lock              # screen locker
    
    # === Fonts ===
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" "Hack" ]; })
    noto-fonts-emoji      # emoji fonts
    
    # === Documents & Reading ===
    newsboat              # RSS reader
    zathura               # PDF viewer
    zathura-pdf-mupdf     # PDF support for zathura
    
    # === Communication ===
    telegram-desktop
    discord
    thunderbird           # email client
    
    # === Browsers ===
    chromium
    brave                 # brave browser
    
    # === Gaming ===
    steam
    lutris                # game manager
    
    # === Productivity ===
    obsidian              # note taking
    
    # === Torrents ===
    qbittorrent
    
    # === Music (Spotify) ===
    spotify
    
    # === NVIDIA ===
    nvidia-settings       # NVIDIA control panel (if using NVIDIA)
    
    # === Documentation ===
    man-pages
    man-db
    
    # === Misc ===
    unzip
    wget
    curl
    figlet                # ASCII art text
    volumeicon            # volume tray icon
  ];

  # ============================================================================
  # ZSH CONFIGURATION
  # ============================================================================
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" ];
    };
    
    shellAliases = {
      # Navigation
      config = "cd ~/.config";
      zshconfig = "nvim ~/.zshrc";
      ":q" = "exit";
      e = "exit";
      
      # System info
      path = "echo -e \${PATH//:/\\\\n}";
      plz = "sudo $(fc -ln -1)";
      free = "free -h";
      
      # Modern CLI replacements
      ls = "eza";
      li = "eza --icons";
      ll = "eza -a";
      lli = "eza -a --icons";
      l = "eza -lh";
      la = "eza -alh";
      lai = "eza -alh --icons";
      llt = "eza -1 --icons --tree --git-ignore";
      tree = "eza --tree";
      cat = "bat";
      
      # Git
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit -m";
      gp = "git push";
      gcl = "git clone";
      gi = "git init";
      gpl = "git pull";
      gco = "git checkout";
      
      # Tmux
      t = "tmux";
      tl = "tmux ls";
      ta = "tmux attach-session -t";
      tn = "tmux new-session -s";
      tk = "tmux kill-session -t";
      
      # Media
      ytdl = "yt-dlp";
      ytdlm = "yt-dlp --extract-audio --audio-format mp3";
      
      # FZF
      search = "fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' | xargs nvim";
      
      # System
      off = "sudo shutdown now";
      restart = "sudo shutdown -r now";
      suspend = "systemctl suspend";
    };
    
    initExtra = ''
      # Zoxide
      eval "$(zoxide init zsh)"
      
      # Rust
      [[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
      
      # Bun
      export BUN_INSTALL="$HOME/.bun"
      export PATH="$BUN_INSTALL/bin:$PATH"
      
      # Additional PATH entries
      export PATH="$HOME/.local/bin:$PATH"
    '';
  };

  # ============================================================================
  # GIT CONFIGURATION
  # ============================================================================
  
  programs.git = {
    enable = true;
    userName = "akhilesh";
    userEmail = "akhi23waghmare@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "nvim";
    };
  };

  # ============================================================================
  # TMUX CONFIGURATION
  # ============================================================================
  
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    baseIndex = 1;
    mouse = true;
    keyMode = "vi";
    terminal = "screen-256color";
    
    extraConfig = ''
      # Reload config
      bind r source-file ~/.tmux.conf \; display '~/.tmux.conf sourced'
      
      # Pane navigation with vim keys
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R
      
      # Pane resizing
      bind -n S-Left resize-pane -L 2
      bind -n S-Right resize-pane -R 2
      bind -n S-Down resize-pane -D 1
      bind -n S-Up resize-pane -U 1
      
      # Window management
      bind -n M-o new-window -c "#{pane_current_path}"
      bind -n M-O break-pane
      bind -n M-Q kill-pane
      
      # Alt + number for window switching
      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9
      
      # Splits
      bind u split-window -vb -c "#{pane_current_path}"
      bind e split-window -v -c "#{pane_current_path}"
      bind n split-window -hb -c "#{pane_current_path}"
      bind i split-window -h -c "#{pane_current_path}"
      
      # Pane zoom
      bind -n M-f resize-pane -Z
      
      # Pane selection by number
      bind 1 select-pane -t:.1
      bind 2 select-pane -t:.2
      bind 3 select-pane -t:.3
      bind 4 select-pane -t:.4
      bind 5 select-pane -t:.5
      
      # Alt for pane navigation
      bind -n M-n select-pane -L
      bind -n M-e select-pane -D
      bind -n M-u select-pane -U
      bind -n M-i select-pane -R
      
      # Swap panes
      bind > swap-pane -D
      bind < swap-pane -U
      bind | swap-pane
      bind -n M-Space next-layout
      
      # Status bar styling
      set -g status-bg '#666666'
      set -g status-fg black
      set -g status-left '[#S]'
      set -g status-right " %R "
      set -g status-justify left
      set -g status-left-length 50
      set -g status-interval 60
      
      # Activity monitoring
      set -g visual-activity on
      setw -g monitor-activity on
      setw -g monitor-bell on
    '';
    
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
    ];
  };

  # ============================================================================
  # KITTY CONFIGURATION
  # ============================================================================
  
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 12;
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      
      # Window
      window_padding_width = 10;
      hide_window_decorations = "yes";
      confirm_os_window_close = 0;
      
      # Cursor
      cursor_shape = "beam";
      cursor_blink_interval = 0;
      
      # Scrollback
      scrollback_lines = 10000;
      
      # URLs
      url_style = "curly";
      
      # Bell
      enable_audio_bell = "no";
      
      # Theme (Catppuccin Mocha inspired)
      background = "#1e1e2e";
      foreground = "#cdd6f4";
      selection_background = "#45475a";
      selection_foreground = "#cdd6f4";
      cursor = "#f5e0dc";
      
      # Colors
      color0 = "#45475a";
      color1 = "#f38ba8";
      color2 = "#a6e3a1";
      color3 = "#f9e2af";
      color4 = "#89b4fa";
      color5 = "#f5c2e7";
      color6 = "#94e2d5";
      color7 = "#bac2de";
      color8 = "#585b70";
      color9 = "#f38ba8";
      color10 = "#a6e3a1";
      color11 = "#f9e2af";
      color12 = "#89b4fa";
      color13 = "#f5c2e7";
      color14 = "#94e2d5";
      color15 = "#a6adc8";
    };
  };

  # ============================================================================
  # FZF CONFIGURATION
  # ============================================================================
  
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
    ];
  };

  # ============================================================================
  # BAT CONFIGURATION
  # ============================================================================
  
  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin-mocha";
      style = "plain";
    };
  };

  # ============================================================================
  # NEOVIM - Using external config
  # ============================================================================
  
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # ============================================================================
  # ROFI CONFIGURATION
  # ============================================================================
  
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "${pkgs.kitty}/bin/kitty";
    theme = "gruvbox-dark-hard";
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      icon-theme = "Papirus-Dark";
      display-drun = " Apps";
      display-run = " Run";
      display-window = " Windows";
    };
  };

  # ============================================================================
  # WAYBAR CONFIGURATION
  # ============================================================================
  
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "battery" "tray" ];
        
        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%Y-%m-%d}";
        };
        
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-icons = [ "" "" "" "" "" ];
        };
        
        network = {
          format-wifi = "{essid} ";
          format-ethernet = "Connected ";
          format-disconnected = "Disconnected ⚠";
        };
        
        pulseaudio = {
          format = "{volume}% {icon}";
          format-muted = "";
          format-icons = {
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };
      };
    };
    
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
      }

      window#waybar {
        background-color: rgba(30, 30, 46, 0.9);
        color: #cdd6f4;
        border-radius: 0;
      }

      #workspaces button {
        padding: 0 8px;
        color: #cdd6f4;
        background: transparent;
        border-radius: 5px;
        margin: 3px;
      }

      #workspaces button.active {
        background: #45475a;
        color: #89b4fa;
      }

      #clock, #battery, #network, #pulseaudio, #tray {
        padding: 0 10px;
        margin: 3px 5px;
        background: #45475a;
        border-radius: 5px;
      }

      #battery.warning {
        background: #f9e2af;
        color: #1e1e2e;
      }

      #battery.critical {
        background: #f38ba8;
        color: #1e1e2e;
      }
    '';
  };

  # ============================================================================
  # DUNST (NOTIFICATIONS)
  # ============================================================================
  
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 300;
        offset = "30x50";
        origin = "top-right";
        transparency = 10;
        frame_color = "#89b4fa";
        font = "JetBrainsMono Nerd Font 10";
        corner_radius = 10;
      };
      
      urgency_low = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 5;
      };
      
      urgency_normal = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 10;
      };
      
      urgency_critical = {
        background = "#1e1e2e";
        foreground = "#f38ba8";
        frame_color = "#f38ba8";
        timeout = 0;
      };
    };
  };

  # ============================================================================
  # PICOM (X11 COMPOSITOR)
  # ============================================================================
  
  services.picom = {
    enable = true;
    fade = true;
    fadeDelta = 5;
    shadow = true;
    shadowOpacity = 0.5;
    backend = "glx";
    vSync = true;
    settings = {
      corner-radius = 10;
      blur = {
        method = "dual_kawase";
        strength = 5;
      };
    };
  };

  # ============================================================================
  # ZATHURA (PDF VIEWER)
  # ============================================================================
  
  programs.zathura = {
    enable = true;
    options = {
      default-bg = "#1e1e2e";
      default-fg = "#cdd6f4";
      recolor = true;
      recolor-lightcolor = "#1e1e2e";
      recolor-darkcolor = "#cdd6f4";
    };
  };

  # ============================================================================
  # CONFIG FILES (raw dotfiles)
  # ============================================================================
  
  # Link your existing Hyprland config
  xdg.configFile = {
    # Hyprland - copy your existing config
    "hypr/hyprland.conf".source = ../../../.config/hypr/hyprland.conf;
    
    # Neovim - copy your existing config
    "nvim".source = ../../../.config/nvim;
    
    # i3 - copy your existing config
    "i3".source = ../../../.config/i3;
    
    # Newsboat
    "newsboat".source = ../../../.newsboat;
    
    # Neofetch
    "neofetch".source = ../../../.config/neofetch;
    
    # Alacritty
    "alacritty".source = ../../../.config/alacritty;
  };

  # ============================================================================
  # FONTS
  # ============================================================================
  
  fonts.fontconfig.enable = true;

  # ============================================================================
  # XDG DIRECTORIES
  # ============================================================================
  
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };
  };
}
