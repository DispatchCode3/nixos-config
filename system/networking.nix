{ config, pkgs, systemSettings, ... }:

{
  networking.useDHCP = false;
  networking.firewall.enable = true;
  networking.networkmanager.enable = true;
}
