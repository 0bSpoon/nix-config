{ lib, ... }:
{
  imports =
    lib.optionals (builtins.pathExists ./hardware-configuration.nix) [ ./hardware-configuration.nix ]
    ++ lib.optionals (builtins.pathExists ./disk-config.nix) [ ./disk-config.nix ];

  networking.hostName = "vm-nixos-test";
  system.stateVersion = "25.11";
}
