{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neofetch
    htop
  ];
}
