let
  settings = import ./settings.nix;
in
{
  description = "Minimal NixOS system with base Home Manager defaults and user overrides";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-${settings.nixosRelease}";

    home-manager = {
      url = "github:nix-community/home-manager/release-${settings.nixosRelease}";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    {
      nixosConfigurations.${settings.hostName} = nixpkgs.lib.nixosSystem {
        system = settings.system;

        specialArgs = {
          inherit settings;
        };

        modules = [
          ./hosts/nixos/default.nix
          ./hosts/nixos/hardware-configuration.nix

          home-manager.nixosModules.default
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit settings;
            };

            home-manager.users.${settings.userName} =
              import (./users + "/${settings.userName}.nix");
          }
        ];
      };
    };
}
