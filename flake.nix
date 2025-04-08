{
  description = "Modular NixOS config with flakes, Hyprland, and Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, hyprland, ... }:
    let
      systemSettings = {
        system = "x86_64-linux";
        timeZone = "America/New_York";
        locale = "en_US.UTF-8";
        bootMountPath = "/boot";
        bootMode = "uefi";
        grubDevice = "/dev/sda";
        extraPackages = with nixpkgs.legacyPackages.x86_64-linux; [ git vim ];
      };

      userSettings = {
        username = "rob";
        wm = "hyprland";
      };

      lib = import ./lib.nix {
        inherit inputs userSettings systemSettings;
      };
    in
    {
      nixosConfigurations.system = nixpkgs.lib.nixosSystem {
        system = systemSettings.system;
        modules = [ ./profiles/minimal/configuration.nix ];
        specialArgs = {
          inherit inputs systemSettings userSettings lib;
        };
      };

      homeConfigurations.user = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${systemSettings.system};
        modules = [ ./profiles/minimal/home.nix ];
        extraSpecialArgs = {
          inherit inputs systemSettings userSettings lib;
        };
      };
    };
}
