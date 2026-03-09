{ settings, ... }:

{
  imports = [
    ../modules/home/base.nix
  ];

  home.username = settings.userName;
  home.homeDirectory = "/home/${settings.userName}";
  home.stateVersion = settings.homeStateVersion;
}
