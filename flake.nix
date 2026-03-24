{
  description = "nixos book flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, disko, home-manager, ... }@inputs:
    let
      homeManagerModule = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.users.bspoon = import ./common/home.nix;
      };
    in
    {
      nixosConfigurations.vm-nixos-test = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/vm-nixos-test/configuration.nix
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          homeManagerModule
        ];
      };

      nixosConfigurations.targon = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/targon/configuration.nix
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          homeManagerModule
        ];
      };
    };
}
