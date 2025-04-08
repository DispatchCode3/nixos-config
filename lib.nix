{ inputs, userSettings, systemSettings }:

let
  inherit (userSettings) wm username;
  inherit (systemSettings) system;

  wmModulePath = ./user/wm/${wm}/${wm}.nix;
  homeDirectory = "/home/${username}";
in
{
  inherit wmModulePath homeDirectory;
}
