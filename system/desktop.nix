{ config, pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.displayManager.defaultSession = "gnome";

  environment.systemPackages = with pkgs; [
    gnome-tweaks
  ];
}