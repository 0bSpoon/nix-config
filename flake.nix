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
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, disko, home-manager, sops-nix, ... }@inputs:
    let
      homeManagerModule = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.sharedModules = [ sops-nix.homeManagerModules.sops ];
      };
    in
    {
      nixosConfigurations.vm-nixos-test = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/vm-nixos-test/configuration.nix
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          homeManagerModule
          { home-manager.users.bspoon = import ./common/home.nix; }
        ];
      };

      nixosConfigurations.targon = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/targon/configuration.nix
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          homeManagerModule
          { home-manager.users.bspoon = import ./common/home.nix; }
        ];
      };
    };
}
