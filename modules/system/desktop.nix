{ settings, ... }:

{
  services.xserver.enable = true;
  services.xserver.windowManager.qtile.enable =
    settings.desktop.windowManager == "qtile";
  services.displayManager.ly.enable =
    settings.desktop.displayManager == "ly";
}
