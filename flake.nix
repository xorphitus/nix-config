{
  description = "My NixOS flake config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # For Darwin
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
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

  outputs = { nixpkgs, home-manager, nixos-wsl, nix-darwin, brew-nix, ... }@inputs:
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

            home-manager.users.${username} = { config, pkgs, ... }:
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
          nixos-wsl.nixosModules.wsl
          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;

            home-manager.users.${username} = { config, pkgs, ... }:
              import ./modules/nixos/home-manager-wsl.nix { inherit config pkgs username; };
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
          _:
          {
            brew-nix.enable = true;
          }
        )
        ./hosts/darwin/macbook-air-m2.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useUserPackages = true;

          home-manager.users.${username} = { pkgs, lib, ... }:
              import ./modules/darwin/home-manager.nix { inherit inputs pkgs lib username; };
        }
      ];
      specialArgs = {
        inherit username;
      };
    };
  };
}
