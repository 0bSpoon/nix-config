# Common system configuration shared across all hosts.
# Host-specific settings (hostName, stateVersion, hardware) are in hosts/*/configuration.nix.

{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "flakes" "nix-command" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [ "ja_JP.UTF-8/UTF-8" ];

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.pipewire.wireplumber.extraConfig."disable-momentum4-mic" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          { "node.name" = "alsa_input.usb-Sonova_Consumer_Hearing_MOMENTUM_4_30284BD06725A9AB3C08-01.mono-fallback"; }
        ];
        actions = {
          update-props = {
            "node.disabled" = true;
          };
        };
      }
    ];
  };

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.bspoon = {
    isNormalUser = true;
    description = "Taiki Matsumoto";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIJ8suCmc+4CLi1wUDO3tQorrlAkQDVfwdKHqmvWyzpQ bSpoon@desktop-fedora"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAMxz+IWydEypgGJ3vr5CieUUtL68iw883lSu2Q9+gm6 int47@windows"
    ];
  };
  
  security.sudo.extraRules = [
    {
      users = [ "bspoon" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  programs = {
    firefox.enable = true;
    nix-ld.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget
    neovim
    git
    gh
  ];

  fonts.packages = with pkgs; [
    corefonts
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    ibm-plex
    monaspace
    nerd-fonts.monaspace
    commit-mono
    nerd-fonts.commit-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    ipafont
  ];

  fonts.fontconfig = {
    antialias = true;
    hinting = {
      enable = true;
      autohint = false;
      style = "slight";
    };
    subpixel = {
      rgba = "rgb";
      lcdfilter = "default";
    };
    defaultFonts = {
      monospace = [
        "Noto Sans Mono"
        "Noto Sans Mono CJK JP"
      ];
      sansSerif = [
        "Noto Sans"
        "Noto Sans CJK JP"
      ];
      serif = [
        "Noto Serif"
        "Noto Serif CJK JP"
      ];
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    openFirewall = true;
  };

  
  fileSystems."/var/log".neededForBoot = true;
  fileSystems."/persist".neededForBoot = true;

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };
}
