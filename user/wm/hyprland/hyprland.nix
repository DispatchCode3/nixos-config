{ pkgs, lib, config, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;

    settings = {
      exec-once = [
        "waybar &"
        "hyprpaper &"
        "hyprlock &"
      ];

      input = {
        kb_layout = "us";
        follow_mouse = 1;
      };

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        layout = "dwindle";
      };
    };
  };

  home.packages = (with pkgs; [
    waybar
    hyprpaper
    hyprlock
  ]);
  # Manage Hyprland config declaratively
  xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
}