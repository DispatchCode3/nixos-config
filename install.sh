#!/usr/bin/env bash
set -euo pipefail

export NIX_CONFIG="experimental-features = nix-command flakes"

DISK="${1:-}"
REPO_URL="https://github.com/DispatchCode3/nixos-config"

if [[ -z "$DISK" ]]; then
  echo "Usage: $0 /dev/sdX"
  exit 1
fi

if [[ ! -b "$DISK" ]]; then
  echo "Error: $DISK is not a valid block device"
  exit 1
fi

if ! command -v nix >/dev/null 2>&1; then
  echo "Error: nix is not available in this environment"
  exit 1
fi

TMP_REPO="$(mktemp -d)"
cleanup() {
  rm -rf "$TMP_REPO"
}
trap cleanup EXIT

echo "Cloning repository to read settings..."
git clone "$REPO_URL" "$TMP_REPO"

if [[ ! -f "$TMP_REPO/settings.nix" ]]; then
  echo "Error: settings.nix not found in repository"
  exit 1
fi

HOST_NAME="$(nix eval --impure --expr "(import $TMP_REPO/settings.nix).hostName" --raw)"
USER_NAME="$(nix eval --impure --expr "(import $TMP_REPO/settings.nix).userName" --raw)"
BOOT_MODE="$(nix eval --impure --expr "(import $TMP_REPO/settings.nix).boot.mode" --raw)"

if [[ -z "$HOST_NAME" || -z "$USER_NAME" || -z "$BOOT_MODE" ]]; then
  echo "Error: failed to read hostName, userName, or boot.mode from settings.nix"
  exit 1
fi

echo "Install target summary:"
echo "  Disk:      $DISK"
echo "  Host:      $HOST_NAME"
echo "  User:      $USER_NAME"
echo "  Boot mode: $BOOT_MODE"
echo
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

if [[ "$BOOT_MODE" == "uefi" ]]; then
  sgdisk \
    -n 1:0:+1G -t 1:ef00 -c 1:boot \
    -n 2:0:+4G -t 2:8200 -c 2:swap \
    -n 3:0:0   -t 3:8300 -c 3:root \
    "$DISK"
elif [[ "$BOOT_MODE" == "bios" ]]; then
  sgdisk \
    -n 1:0:+4G -t 1:8200 -c 1:swap \
    -n 2:0:0   -t 2:8300 -c 2:root \
    "$DISK"
else
  echo "Error: unsupported boot.mode '$BOOT_MODE' in settings.nix"
  exit 1
fi

partprobe "$DISK"
udevadm settle

if [[ "$DISK" =~ nvme|mmcblk|loop ]]; then
  PART_PREFIX="${DISK}p"
else
  PART_PREFIX="${DISK}"
fi

if [[ "$BOOT_MODE" == "uefi" ]]; then
  BOOT_PART="${PART_PREFIX}1"
  SWAP_PART="${PART_PREFIX}2"
  ROOT_PART="${PART_PREFIX}3"

  mkfs.fat -F32 "$BOOT_PART"
  mkswap "$SWAP_PART"
  mkfs.ext4 -F -L nixos "$ROOT_PART"

  swapon "$SWAP_PART"
  mount "$ROOT_PART" /mnt
  mkdir -p /mnt/boot
  mount "$BOOT_PART" /mnt/boot
else
  SWAP_PART="${PART_PREFIX}1"
  ROOT_PART="${PART_PREFIX}2"

  mkswap "$SWAP_PART"
  mkfs.ext4 -F -L nixos "$ROOT_PART"

  swapon "$SWAP_PART"
  mount "$ROOT_PART" /mnt
fi

nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix /tmp/hardware-configuration.nix

rm -rf /mnt/etc/nixos
git clone "$REPO_URL" /mnt/etc/nixos

mkdir -p "/mnt/etc/nixos/hosts/$HOST_NAME"
cp /tmp/hardware-configuration.nix "/mnt/etc/nixos/hosts/$HOST_NAME/hardware-configuration.nix"

cd /mnt/etc/nixos
git add "hosts/$HOST_NAME/hardware-configuration.nix"

nixos-install --flake "/mnt/etc/nixos#$HOST_NAME"

echo
echo "Installation complete."
echo "Set the user password before rebooting:"
echo "nixos-enter --root /mnt -c 'passwd $USER_NAME'"
echo
echo "Then reboot."
