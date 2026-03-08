{ config, pkgs, ... }:

{
  home.username = "rob";
  home.homeDirectory = "/home/rob";

  home.packages = [ ];

  home.stateVersion = "25.11";
}
