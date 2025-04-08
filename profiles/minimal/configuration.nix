{ config, pkgs, lib, inputs, userSettings, systemSettings, ... }:

{
  imports = [
    ../../system/hardware-configuration.nix
    ../../system/bluetooth.nix
    ../../system/bootloader.nix
    ../../system/desktop.nix
    ../../system/locale.nix
    ../../system/networking.nix
    ../../system/shell.nix
    ../../system/time.nix
    ../../system/users.nix
  ];

  system.stateVersion = "24.11";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    home-manager
    vim
    git
    wget
  ];
}