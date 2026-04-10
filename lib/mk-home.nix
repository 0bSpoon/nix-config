{ inputs }:
{ hostName, host }:
let
  pkgs = import inputs.nixpkgs {
    system = host.system;
    config.allowUnfree = true;
  };
in
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  extraSpecialArgs = {
    inherit inputs hostName;
    inherit (host) username homeDirectory;
  };

  modules = [
    inputs.sops-nix.homeManagerModules.sops
    host.userModule
    host.homeProfile
  ];
}
