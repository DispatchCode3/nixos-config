{ pkgs, userSettings, ... }:

{ 
  home.packages = with pkgs; [
    neovim
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
}