{
  description = "My NixOS flake config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # For Darwin
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs.brew-api.follows = "brew-api";
    };
    brew-api = {
      url = "github:BatteredBunny/brew-api";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, brew-nix, brew-api }@inputs:
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

      wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos/wsl.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;

            home-manager.users.${username} = { config, pkgs, lib, ... }:
              import ./modules/shared/home-manager.nix { inherit config pkgs username; };
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
        brew-nix.darwinModules.default
        (
          { pkgs, ... }:
          {
            brew-nix.enable = true;
          }
        )
        ./hosts/darwin/macbook-air-m2.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useUserPackages = true;

          home-manager.users.${username} = { config, pkgs, lib, ... }:
              import ./modules/darwin/home-manager.nix { inherit inputs pkgs lib username; };
        }
      ];
      specialArgs = {
        inherit username;
      };
    };
  };
}
