{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;

    settings = {
      exec-once = [ "waybar &" "hyprpaper &" ];
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

  xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
}
