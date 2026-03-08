{ config, pkgs, ... }:

{
  networking.hostName = "nixos";

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  users.users.rob = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  services.xserver.enable = true;
  services.xserver.windowManager.qtile.enable = true;
  services.displayManager.ly.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    alacritty
  ];

  system.stateVersion = "25.11";
}
