{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../common/system.nix
    ./disk-config.nix
    ./gpu.nix
    ./dualboot.nix
  ];
  networking.hostName = "targon";
  system.stateVersion = "25.11";
}
