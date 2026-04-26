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
    inputs.niri.homeModules.config
    inputs.niri.homeModules.stylix
    inputs.dms.homeModules.dank-material-shell
    inputs.dms.homeModules.niri
    ../modules/theme/stylix.nix
    host.userModule
    host.homeProfile
  ];
}
