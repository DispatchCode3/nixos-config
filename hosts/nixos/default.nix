{ ... }:

let
  settings = import ./settings.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/base.nix
    ../../modules/system/boot.nix
    ../../modules/system/networking.nix
    ../../modules/system/desktop.nix
  ];

  _module.args = {
    inherit settings;
  };

  networking.hostName = settings.hostName;
  system.stateVersion = settings.systemStateVersion;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    inherit settings;
  };

  home-manager.users.${settings.userName} =
    import (../../users + "/${settings.userName}.nix");
}
