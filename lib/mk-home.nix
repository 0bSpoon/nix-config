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
    inputs.stylix.homeModules.stylix
    inputs.sops-nix.homeManagerModules.sops
    ../modules/theme/stylix.nix
    host.userModule
    host.homeProfile
  ];
}
