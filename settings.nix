let
  installVersion = "25.11";
in
{
  system = "x86_64-linux";

  nixosRelease = "25.11";
  systemStateVersion = installVersion;
  homeStateVersion = installVersion;

  hostName = "nixos";
  userName = "rob";

  timeZone = "America/Chicago";
  locale = "en_US.UTF-8";

  boot = {
    mode = "uefi";
  };

  desktop = {
    displayManager = "ly";
    windowManager = "qtile";
  };
}
