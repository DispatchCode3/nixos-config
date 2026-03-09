{ pkgs, settings, ... }:

{
  time.timeZone = settings.timeZone;
  i18n.defaultLocale = settings.locale;

  users.users.${settings.userName} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    alacritty
  ];
}
