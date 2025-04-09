{ config, pkgs, lib, inputs, systemSettings, ... }:

{
  environment.systemPackages = with pkgs; [
    zsh
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      
      ll = "ls -l";

      # Rebuild NixOS system
      sys = "nixos-rebuild switch --use-remote-sudo --flake .#system";

      # Rebuild Home Manager user config
      hm = "home-manager switch --flake .#user";

      # Update flake inputs (e.g., nixpkgs/home-manager)
      flake-update = "nix flake update && echo '✅ flake.lock updated!'";

      # Rebuild everything (system and user)
      rebuild-all = "sys && hm";

      # Generate hardware-configuration and move it
      generate-hardware = "nixos-generate-config --show-hardware-config > ~/.dotfiles/system/hardware-configuration.nix";
    };
  };
}
