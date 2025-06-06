{
  description = "My NixOS flake config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nix-darwin, nixpkgs, home-manager }@inputs:
let
  username = "xorphitus";
in
  {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos/desktop.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;

            home-manager.users.${username} = { config, pkgs, lib, ... }:
              import ./modules/nixos/home-manager.nix { inherit config pkgs username; };
          }
        ];
        specialArgs = {
          inherit inputs username;
        };
      };

      vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos/vm.nix
        ];
      };
    };

    darwinConfigurations.macbook-air-m2 = nix-darwin.lib.darwinSystem {
      modules = [
        ./hosts/darwin/macbook-air-m2.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useUserPackages = true;
          home-manager.useGlobalPkgs = true;

          home-manager.users.${username} = import ./modules/darwin/home-manager.nix;
          home-manager.users.${username} = { config, pkgs, lib, ... }:
              import ./modules/darwin/home-manager.nix { inherit pkgs username; };
        }
      ];
      specialArgs = {
        inherit username;
      };
    };
  };
}
