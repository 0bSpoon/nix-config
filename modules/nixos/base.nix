{ pkgs, username, ... }:
{
  imports = [
    ../../overlays/workarounds.nix
  ];

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Asia/Tokyo";

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

  users.users.${username} = {
    isNormalUser = true;
    description = "Taiki Matsumoto";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIJ8suCmc+4CLi1wUDO3tQorrlAkQDVfwdKHqmvWyzpQ bSpoon@desktop-fedora"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAMxz+IWydEypgGJ3vr5CieUUtL68iw883lSu2Q9+gm6 int47@windows"
    ];
  };

  users.users.root.hashedPassword = "!";
  system.activationScripts.lockRootPassword.text = ''
    ${pkgs.shadow}/bin/usermod -p '!' root
  '';

  security.sudo.extraRules = [
    {
      users = [ username ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  programs.nix-ld.enable = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    gh
    neovim
    wget
  ];

  fileSystems."/var/log".neededForBoot = true;
  fileSystems."/persist".neededForBoot = true;

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };
}
