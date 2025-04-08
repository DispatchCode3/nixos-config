{ config, pkgs, userSettings, ... }:

{
  time.timeZone = systemSettings.timeZone;
  services.timesyncd.enable = true;
}