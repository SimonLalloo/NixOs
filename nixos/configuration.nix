# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

# ================================================================================ #

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
 boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "i8042.direct" "i8042.dumbkbd" "i915.enable_psr=0" ];
  	# Other boot params: "ipv6.disable=1" 

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

# ================================================================================ #

  networking.hostName = "nixos"; # Define your hostname.
  
  # Enable networking
  networking.networkmanager.enable = true;
  # networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.

  # This settings seems to be reset by NetworkManager
  networking.enableIPv6 = false;

  networking.firewall.enable = true;

  networking.nameservers = [ "1.1.1.1" "8.8.8.8" "8.8.4.4" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# ================================================================================ #

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

# ================================================================================ #

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

# ================================================================================ #

  # Hyprland
  programs.hyprland = {
    enable = true;

    ## Note that additional settings may be necessary for Nvidia systems
  };

  # Desktop portals
  xdg.portal.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Allow screen-locker to login
  security.pam.services.swaylock = {};

# ================================================================================ #

  # Enable CUPS to print documents.
  services.printing.enable = true;

# ================================================================================ #

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

# ================================================================================ #

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

# ================================================================================ #

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.simon = {
    isNormalUser = true;
    description = "Simon";
    extraGroups = [ "networkmanager" "wheel" "video" "vboxusers" ];
    packages = with pkgs; [
      firefox
      chromium
    ];
  };

# ================================================================================ #

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
   # Base stuff
   vim
   git
   meld         # Git diff & merge tool
   stow 		# For bringing in my dotfiles 
   btop			# System monitoring
   home-manager

   # WM stuff
   dunst 		# Notification daemon
   libnotify		# dunst dependency
   swww			# Wallpaper daemon
   rofi-wayland 	# App launcher
   networkmanagerapplet # Applet for NetworkManager
   light		# Brightness control
   swaylock-effects	# Screen locker
   swayidle		# Idle and locking
   wl-clipboard		# Clipboard manager
  # font-awesome		# Fonts required for waybar
   nerdfonts		# Fonts with icons

   (pkgs.waybar.overrideAttrs (oldAttrs: { # bar
       mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
     })
   )
	
   # Communication
   discord		# Chat for _gamers_
   zoom-us		# zoom

   # Terminal
   kitty		# Terminal emulator
   tmux			# Terminal multiplexor

   # Editing
   neovim 		# Vim, but better 

   # Network
   dig			# DNS
   wireshark		# Network monitoring

   # Images
   grim			# Screenshots
   slurp		# Select region
   imagemagick	# Image editing
   gimp         # Gnu image manipulation tool

   # Languages
   llvm			# C?
   clang		# More C?
   mysql80		# MySQL
   mysql-workbench	# MySQL editor

   (python3.withPackages(ps: with ps; [ numpy scipy matplotlib pandas ]))

   # Notes and files
   obsidian		# Notes
   syncthing	# P2P file sync
   zip			# Zip stuff
   unzip		# Zip in reverse

   virtualbox
  ];

   virtualisation.virtualbox.host.enable = true;
   # virtualisation.virtualbox.guest.enable = true;
   users.extraGroups.vboxusers.members = [ "Simon" ];

# ================================================================================ #

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable the backlight daemon
  programs.light.enable = true;

  # Enable Syncthing to automatically sync files
  services.syncthing = {
    enable = true;
    user = "simon";
    dataDir = "/home/simon/Documents"; # Default folder for new synced folders
    configDir = "/home/simon/Documents/.config/syncthing";
  };

/*
  # Locking and sleeping
  services.swayidle = {
    enable = true;
    events = [
      { event = "lock"; command = "${pkgs.swaylock}/bin/swaylock";}
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock";}
      # { event = "after-resume"; command = "${pkgs.sway}/bin/swaymsg \"output * toggle\"";}
    ];
    timeouts = [
      { timeout = 600; command = "${pkgs.swaylock}/bin/swaylock";}
      # { timeout = 1200; command = "${pkgs.sway}/bin/swaymsg \"output * toggle\"";}
    ];
  };
*/

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
