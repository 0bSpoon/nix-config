{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../common/system.nix
    ./nvidia.nix
    ./dualboot.nix
  ];
  networking.hostName = "targon";
  system.stateVersion = "25.11";
}
