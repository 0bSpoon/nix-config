{ lib, ... }:
{
  imports =
    lib.optionals (builtins.pathExists ./hardware-configuration.nix) [ ./hardware-configuration.nix ]
    ++ lib.optionals (builtins.pathExists ./disk-config.nix) [ ./disk-config.nix ]
    ++ lib.optionals (builtins.pathExists ./gpu.nix) [ ./gpu.nix ]
    ++ lib.optionals (builtins.pathExists ./dualboot.nix) [ ./dualboot.nix ];

  networking.hostName = "targon";
  system.stateVersion = "25.11";
}
