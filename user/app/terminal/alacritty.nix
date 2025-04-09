{ pkgs, userSettings, ... }:

{ 
  home.packages = with pkgs; [
    alacritty
  ];
}