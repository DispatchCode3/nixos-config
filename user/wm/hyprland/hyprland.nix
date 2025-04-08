{ pkgs, inputs, userSettings, ... }:

let
  hyprlandPkg = inputs.hyprland.packages.${pkgs.system}.default;
in {
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprlandPkg;

    settings = {
      exec-once = [
        "waybar &"
        "hyprpaper &"
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

  # Optional: portable config
  xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
}
