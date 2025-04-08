#!/usr/bin/env bash
echo "🔍 Validating flake..."
nix flake check --show-trace
