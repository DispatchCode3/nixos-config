{ config, pkgs, inputs, userSettings, systemSettings, lib, ... }:

{
  imports = [
    ../../user/terminal.nix
    ../../user/misc.nix
    ../../user/development.nix
    (import lib.wmModulePath)
  ];

  home.username = userSettings.username;
  home.homeDirectory = lib.homeDirectory;
  home.stateVersion = "23.11";
}
