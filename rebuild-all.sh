#!/usr/bin/env bash
sudo nixos-rebuild switch --flake .#system --use-remote-sudo
home-manager switch --flake .#user
