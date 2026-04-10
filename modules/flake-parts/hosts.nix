{ config, inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
  mkNixosHost = import ../../lib/mk-nixos-host.nix { inherit inputs; };
  nixosHosts = lib.filterAttrs (_: host: host.kind == "nixos") config.flake.inventory;
in
{
  flake.nixosConfigurations = lib.mapAttrs (
    hostName: host:
    mkNixosHost {
      inherit hostName host;
    }
  ) nixosHosts;
}
