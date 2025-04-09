{ pkgs, userSettings, ... }:

{ 
  home.packages = with pkgs; [
    firefox
  ];
}