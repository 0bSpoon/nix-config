{
  description = "nixos book flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    {
      nixosConfigurations.vm-nixos-test = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ 
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.bspoon = import ./home.nix;
          }
          ];
      };
    };
}
