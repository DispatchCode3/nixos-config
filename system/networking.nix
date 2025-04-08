{ config, pkgs, systemSettings, ... }:

{
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true; # replace if needed
  networking.firewall.enable = true;
  networking.networkmanager.enable = true;
}
