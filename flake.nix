{
  description = "multi-platform home lab flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
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
    inputs:
    let
      inventory = {
        targon = {
          kind = "nixos";
          system = "x86_64-linux";
          username = "bspoon";
          homeDirectory = "/home/bspoon";
          hostModule = ./hosts/targon;
          userModule = ./users/bspoon/home.nix;
          nixosProfile = ./profiles/nixos/laptop.nix;
          homeProfile = ./profiles/home/personal-desktop.nix;
        };

        zaun = {
          kind = "nixos";
          system = "x86_64-linux";
          username = "bspoon";
          homeDirectory = "/home/bspoon";
          hostModule = ./hosts/zaun;
          userModule = ./users/bspoon/home.nix;
          nixosProfile = ./profiles/nixos/server.nix;
          homeProfile = ./profiles/home/server-admin.nix;
        };

        vm-nixos-test = {
          kind = "nixos";
          system = "x86_64-linux";
          username = "bspoon";
          homeDirectory = "/home/bspoon";
          hostModule = ./hosts/vm-nixos-test;
          userModule = ./users/bspoon/home.nix;
          nixosProfile = ./profiles/nixos/desktop.nix;
          homeProfile = ./profiles/home/personal-desktop.nix;
        };
      };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./modules/flake-parts/per-system.nix
        ./modules/flake-parts/hosts.nix
        ./modules/flake-parts/homes.nix
        ./modules/flake-parts/android.nix
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      flake.inventory = inventory;
    };
}
