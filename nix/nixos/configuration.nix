# NixOS Configuration
# Edit this configuration file to define what should be installed on your system.
# For a full list of options, see: https://nixos.org/manual/nixos/stable/options

{ config, pkgs, inputs, ... }:

{
  imports = [
    # Include the results of the hardware scan
    ./hardware-configuration.nix
  ];

  # ============================================================================
  # BOOTLOADER
  # ============================================================================
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ============================================================================
  # NETWORKING
  # ============================================================================
  
  networking.hostName = "dopamine";
  networking.networkmanager.enable = true;

  # ============================================================================
  # TIME & LOCALE
  # ============================================================================
  
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_IN.UTF-8";

  # ============================================================================
  # USER ACCOUNT
  # ============================================================================
  
  users.users.dopamine = {
    isNormalUser = true;
    description = "dopamine";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    shell = pkgs.zsh;
  };

  # ============================================================================
  # NIX SETTINGS
  # ============================================================================
  
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  # ============================================================================
  # SYSTEM PACKAGES
  # ============================================================================
  
  environment.systemPackages = with pkgs; [
    # Essential
    vim
    wget
    curl
    git
    
    # Utilities
    htop
    file
    which
    tree
    unzip
    zip
    pciutils
    usbutils
  ];

  # ============================================================================
  # SHELL
  # ============================================================================
  
  programs.zsh.enable = true;

  # ============================================================================
  # DISPLAY & WINDOW MANAGERS
  # ============================================================================
  
  # Hyprland (Wayland)
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };

  # i3 (X11) - optional, enable if you want both
  # services.xserver = {
  #   enable = true;
  #   windowManager.i3.enable = true;
  # };

  # Display Manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # ============================================================================
  # AUDIO (PipeWire)
  # ============================================================================
  
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # ============================================================================
  # BLUETOOTH
  # ============================================================================
  
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # ============================================================================
  # GRAPHICS
  # ============================================================================
  
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Uncomment for NVIDIA:
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = false;
  #   open = false;
  #   nvidiaSettings = true;
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  # };
  # services.xserver.videoDrivers = ["nvidia"];

  # ============================================================================
  # FONTS
  # ============================================================================
  
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" "Hack" ]; })
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };
  };

  # ============================================================================
  # SERVICES
  # ============================================================================
  
  services.printing.enable = true;  # CUPS for printing
  services.dbus.enable = true;      # D-Bus messaging
  
  # Polkit for privilege escalation
  security.polkit.enable = true;

  # ============================================================================
  # XDG PORTALS (for Wayland screen sharing, etc.)
  # ============================================================================
  
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # ============================================================================
  # SYSTEM VERSION
  # ============================================================================
  
  # This determines the NixOS release from which the default settings
  # for stateful data were taken. Don't change without reading docs.
  system.stateVersion = "24.05";
}
