{ config, pkgs, ... }:

{
  home.username = "rob";
  home.homeDirectory = "/home/rob";

  home.stateVersion = "25.11";

  home.packages = [ ];
}
