{ config, pkgs, lib, inputs, userSettings, systemSettings, ... }:

{
  imports = [
    (import ../../user/app/browser/${userSettings.browser}.nix)
    (import ../../user/app/editor/${userSettings.editor}/${userSettings.editor}.nix)
    (import ../../user/app/terminal/${userSettings.term}.nix)
    # (import ../../user/wm/${userSettings.wm}/${userSettings.wm}.nix)
    ../../user/app/git/git.nix
  ];
  
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  home.username = userSettings.username;
  home.homeDirectory = "/home/${userSettings.username}";
  
  home.packages = with pkgs; [

  ];
}
