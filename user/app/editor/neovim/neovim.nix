{ pkgs, userSettings, ... }:

{ 
  home.packages = with pkgs; [
    neovim
  ];

  programs.neovim = {
    viAlias = true;
    vimAlias = true;
  };
}