{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../common/system.nix
    ./disk-config.nix
    ./nvidia.nix
    ./dualboot.nix
  ];
  networking.hostName = "targon";
  system.stateVersion = "25.11";

  fileSystems."/var/log".neededForBoot = true;
  fileSystems."/persist".neededForBoot = true;

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };
}
