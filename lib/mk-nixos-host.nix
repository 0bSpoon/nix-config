{ inputs }:
{ hostName, host }:
let
  lib = inputs.nixpkgs.lib;
  inherit (host)
    system
    username
    homeDirectory
    hostModule
    nixosProfile
    ;
  homeProfile = host.homeProfile or null;
  userModule = host.userModule or null;
in
inputs.nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs = {
    inherit
      inputs
      hostName
      username
      homeDirectory
      ;
  };

  modules = [
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
    inputs.sops-nix.nixosModules.sops
    ../modules/theme/stylix.nix
    nixosProfile
    hostModule
    {
      networking.hostName = lib.mkDefault hostName;

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {
        inherit
          inputs
          hostName
          username
          homeDirectory
          ;
      };
      home-manager.sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
      home-manager.users = lib.optionalAttrs (homeProfile != null && userModule != null) {
        "${username}" = {
          imports = [
            userModule
            homeProfile
          ];
        };
      };
    }
  ];
}
