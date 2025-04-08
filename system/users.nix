{ config, pkgs, userSettings, ... }:

{
  users.users.${userSettings.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
  };
}
