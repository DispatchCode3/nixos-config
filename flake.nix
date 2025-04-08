{
  description = "Flake of DispatchCode3";

  outputs = inputs@{ self, ... }:
    let
      # ---- SYSTEM SETTINGS ---- #
      systemSettings = {
        system = "x86_64-linux";
        hostname = "rb3";
        profile = "minimal"; # select a profile defined from my profiles directory
        timezone = "America/Chicago";
        locale = "en_US.UTF-8";
        bootMode = "uefi"; # uefi or bios
        bootMountPath = "/boot"; # only used for uefi boot mode
        grubDevice = "/dev/sda"; # only used for bios boot mode
        gpuType = "intel"; # amd, intel or nvidia
      };
      # ---- USER SETTINGS ---- #
      userSettings = {
        username = "rob";
        name = "Rob";
        email = "dispatchcode3@gmail.com";
        dotfilesDir = "~/.dotfiles";   
        browser = "firefox";
        editor = "neovim";
        term = "alacritty";
        theme = "";
        wm = "hyprland";
        wmType = if ((wm == "hyprland") || (wm == "plasma")) then "wayland" else "x11";
      };

        pkgs = import nixpkgs {
          system = systemSettings.system;
          config.allowUnfree = true;
        };
        
        lib = inputs.nixpkgs.lib;

    in
    {
      nixosConfigurations.system = lib.nixosSystem {
        system = systemSettings.system;
        modules = [ 
          (./. + "/profiles/${systemSettings.profile}/configuration.nix")
        ];
        specialArgs = {
          inherit inputs systemSettings userSettings;
        };
      };

      homeConfigurations.user = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ 
          (./. + "/profiles/${systemSettings.profile}/home.nix")
          ];
        extraSpecialArgs = {
          inherit inputs systemSettings userSettings;
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
  };
  };
}
