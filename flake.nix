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

  outputs = { self, nix-darwin, nixpkgs, home-manager }@inputs: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos/desktop.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;

            home-manager.users.xorphitus = import ./modules/nixos/home-manager.nix;
          }
        ];
        specialArgs = { inherit inputs; };
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

          home-manager.users.xorphitus = import ./modules/darwin/home-manager.nix;
        }
      ];
    };
  };
}
