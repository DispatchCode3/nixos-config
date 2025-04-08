{ config, pkgs, inputs, userSettings, systemSettings, ... }:

{
  imports = [
    ../../system/hardware-configuration.nix
    ../../system/boot.nix
    ../../system/networking.nix
    ../../system/users.nix
  ];

  nixpkgs.hostPlatform = systemSettings.system;

  time.timeZone = systemSettings.timeZone;
  i18n.defaultLocale = systemSettings.locale;

  environment.systemPackages = with pkgs; systemSettings.extraPackages;

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.defaultSession = "hyprland";
}
