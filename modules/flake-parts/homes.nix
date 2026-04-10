{ config, inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
  mkHome = import ../../lib/mk-home.nix { inherit inputs; };
  homeTargets = lib.filterAttrs (
    _: host:
    (host.kind == "home-manager" || host.kind == "nixos") && (host ? homeProfile) && (host ? userModule)
  ) config.flake.inventory;
in
{
  flake.homeConfigurations = lib.mapAttrs' (
    hostName: host:
    lib.nameValuePair "${host.username}@${hostName}" (mkHome {
      inherit hostName host;
    })
  ) homeTargets;
}
