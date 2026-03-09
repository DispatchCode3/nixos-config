{ config, lib, pkgs, ... }:

let
  userName = config.home.username;
  extraPath = ../../users + "/${userName}/dotfiles/alacritty/extra.toml";
  extraExists = builtins.pathExists extraPath;

  baseConfig = pkgs.writeText "alacritty-base.toml" ''
    [window]
    dynamic_title = true

    [window.padding]
    x = 8
    y = 8

    [scrolling]
    history = 10000

    [font]
    size = 11.0

    [cursor]
    unfilled_hollow = false

    [cursor.style]
    shape = "Block"
    blinking = "Off"
  '';

  finalConfig = pkgs.writeText "alacritty.toml" (
    builtins.readFile baseConfig
    + lib.optionalString extraExists ("\n" + builtins.readFile extraPath)
  );
in
{
  programs.alacritty.enable = true;

  xdg.configFile."alacritty/alacritty.toml".source = finalConfig;
}
