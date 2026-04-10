{ config, inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
  mkAndroid = import ../../lib/mk-android.nix { inherit inputs; };
  androidHosts = lib.filterAttrs (_: host: host.kind == "android") config.flake.inventory;
in
{
  flake.nixOnDroidConfigurations = lib.mapAttrs (
    hostName: host:
    mkAndroid {
      inherit hostName host;
    }
  ) androidHosts;
}
