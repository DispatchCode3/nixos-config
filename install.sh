#!/usr/bin/env bash
set -euo pipefail

DISK="${1:-}"

if [[ -z "$DISK" ]]; then
  echo "Usage: $0 /dev/sdX"
  exit 1
fi

if [[ ! -b "$DISK" ]]; then
  echo "Error: $DISK is not a valid block device"
  exit 1
fi

echo "About to erase and install to: $DISK"
lsblk "$DISK"
read -rp "Type YES to continue: " CONFIRM

if [[ "$CONFIRM" != "YES" ]]; then
  echo "Aborted."
  exit 1
fi

swapoff -a || true
umount -R /mnt 2>/dev/null || true

sgdisk --zap-all "$DISK"
wipefs -a "$DISK"

sgdisk \
  -n 1:0:+1G -t 1:ef00 -c 1:boot \
  -n 2:0:+4G -t 2:8200 -c 2:swap \
  -n 3:0:0   -t 3:8300 -c 3:root \
  "$DISK"

partprobe "$DISK"
udevadm settle

BOOT_PART="${DISK}1"
SWAP_PART="${DISK}2"
ROOT_PART="${DISK}3"

if [[ "$DISK" =~ nvme|mmcblk|loop ]]; then
  BOOT_PART="${DISK}p1"
  SWAP_PART="${DISK}p2"
  ROOT_PART="${DISK}p3"
fi

mkfs.fat -F32 "$BOOT_PART"
mkswap "$SWAP_PART"
mkfs.ext4 -F -L nixos "$ROOT_PART"

swapon "$SWAP_PART"
mount "$ROOT_PART" /mnt
mkdir -p /mnt/boot
mount "$BOOT_PART" /mnt/boot

nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix /tmp/hardware-configuration.nix

rm -rf /mnt/etc/nixos
git clone https://github.com/DispatchCode3/nixos-config /mnt/etc/nixos

mkdir -p /mnt/etc/nixos/hosts/nixos
cp /tmp/hardware-configuration.nix /mnt/etc/nixos/hosts/nixos/hardware-configuration.nix

cd /mnt/etc/nixos
git add hosts/nixos/hardware-configuration.nix

nixos-install --flake /mnt/etc/nixos#${HOSTNAME:-nixos}

echo
echo "Installation complete."
echo "Set the user password before rebooting:"
echo "nixos-enter --root /mnt -c 'passwd $(nix eval --impure --expr \"(import /mnt/etc/nixos/settings.nix).userName\" --raw)'"
echo
echo "Then reboot."
