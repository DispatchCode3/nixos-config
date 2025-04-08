{ pkgs, userSettings, ... }:

{ 
  home.packages = with pkgs; [
    alacritty
  ];

  programs.alacritty = {
    enable = true;
  };
}