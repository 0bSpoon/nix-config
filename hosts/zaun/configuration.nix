{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../common/system.nix
  ];
  networking.hostName = "zaun";
  system.stateVersion = "25.11";
}
