{ settings, ... }:

{
  imports = [
    ../../modules/system/base.nix
    ../../modules/system/boot.nix
    ../../modules/system/networking.nix
    ../../modules/system/desktop.nix
  ];

  networking.hostName = settings.hostName;

  system.stateVersion = settings.systemStateVersion;
}
