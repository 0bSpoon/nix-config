{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../common/system.nix
    ./disk-config.nix
  ];
  networking.hostName = "vm-nixos-test";
  system.stateVersion = "25.11";
}
