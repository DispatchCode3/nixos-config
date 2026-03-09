let
  installVersion = "25.11";
in
{
  hostName = "nixos";
  userName = "rob";

  timeZone = "America/Chicago";
  locale = "en_US.UTF-8";

  systemStateVersion = installVersion;
  homeStateVersion = installVersion;

  boot = {
    mode = "uefi";
  };

  desktop = {
    displayManager = "ly";
    windowManager = "qtile";
  };
}
