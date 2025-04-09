{ config, pkgs, systemSettings, ... }:

{
  time.timeZone = systemSettings.timezone;
  services.timesyncd.enable = true;
}