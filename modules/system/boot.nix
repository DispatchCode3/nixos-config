{ lib, settings, ... }:

{
  config = lib.mkMerge [
    (lib.mkIf (settings.boot.mode == "uefi") {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
    })

    (lib.mkIf (settings.boot.mode == "bios") {
      boot.loader.grub.enable = true;
      boot.loader.grub.device = "/dev/sda";
    })
  ];
}
