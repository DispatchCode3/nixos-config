# NixOS Base Configuration

Minimal reproducible NixOS installation using **flakes + Home Manager**.

## Goals

- Clean base install
- Minimal system packages
- Usable defaults for common tools
- Easy per-user overrides
- Installer edits only **two files**

---

# Install

Boot the **NixOS installer ISO**, then run:

```bash
sudo -i
export NIX_CONFIG="experimental-features = nix-command flakes"
git clone https://github.com/DispatchCode3/nixos-config
cd nixos-config
chmod +x install.sh
./install.sh /dev/sda
```

The installer will:

1. Wipe the disk
2. Partition it
3. Generate hardware configuration
4. Clone the repo into `/mnt/etc/nixos`
5. Install the system via flake

When installation finishes:

```bash
nixos-enter --root /mnt -c 'passwd <user>'
reboot
```

The username comes from `hosts/nixos/settings.nix`.

---

# Files You Edit

A normal install should only require editing:

## `hosts/nixos/settings.nix`

System-wide install configuration.

Examples:

- `hostName`
- `userName`
- boot mode
- timezone
- locale

---

## `users/<username>.nix`

User configuration entrypoint.

This imports the base Home Manager configuration and allows overrides.

---

## Optional: User Dotfiles

```
users/<username>/dotfiles/
```

Used for overriding base configs.

Examples:

- vim
- git
- alacritty
- qtile

---

# Repository Layout

```
flake.nix
install.sh
README.md

hosts/
  nixos/
    default.nix
    settings.nix
    hardware-configuration.nix

modules/system/
  base.nix
  boot.nix
  networking.nix
  desktop.nix

modules/home/
  base.nix
  vim.nix
  git.nix
  alacritty.nix
  qtile.nix

users/
  <user>.nix
  <user>/dotfiles/
```

---

# Configuration Layers

The system is built in layers.

## Settings

`hosts/nixos/settings.nix`

Defines:

- host name
- username
- boot mode
- locale
- timezone
- system state versions

---

## System Modules

Located in:

```
modules/system/
```

Handle machine-level configuration:

- bootloader
- networking
- desktop session
- base packages
- user creation

---

## Base Home Manager Profile

Located in:

```
modules/home/
```

Provides default configs for:

- Vim
- Git
- Alacritty
- Qtile

These give the system a usable out-of-box environment.

---

## User Overrides

Located in:

```
users/<username>/
```

User config imports the base profile and may override it.

---

# Dotfile Behavior

| Application | Behavior |
|-------------|----------|
| Vim | Base config + user additions |
| Git | Base config + user additions |
| Alacritty | Base config + user additions |
| Qtile | Base config replaced if user config exists |

Example override:

```
users/rob/dotfiles/vim/extra.vim
```

---

# Upgrading

To upgrade the system:

```bash
sudo nixos-rebuild switch --flake .#nixos
```

If you later move to a newer NixOS release, update the flake input pins in:

```
flake.nix
```

Do **not** change:

```
systemStateVersion
homeStateVersion
```

These are compatibility locks and normally remain at the original install version.

---

# System Packages

Installed globally:

```
vim
wget
git
alacritty
```

Desktop stack:

```
Qtile
Ly
NetworkManager
```

---

# Philosophy

This repository aims for:

- Reproducible installs
- Minimal base system
- Sane defaults
- Simple overrides
- Easy expansion to additional users or hosts
