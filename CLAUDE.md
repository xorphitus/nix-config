# CLAUDE.md
## Overview

This is a personal NixOS/nix-darwin configuration repository using Nix Flakes. It provides configurations for:

- **NixOS Linux desktop** (x86_64-linux) - Main desktop with Hyprland, NVIDIA support, dual-boot Windows
- **NixOS WSL** (x86_64-linux) - WSL configuration
- **NixOS VM** (x86_64-linux) - Virtual machine configuration
- **macOS** (aarch64-darwin) - MacBook Air M2 configuration

## Structure
- `flake.nix` - Main flake configuration with inputs (nixpkgs, home-manager, nix-darwin, brew-nix)
- `hosts/` - Host-specific configurations
  - `nixos/` - NixOS configurations (desktop, WSL, vm, common)
  - `darwin/` - macOS configurations
- `modules/` - Shared configuration modules
  - `nixos/` - NixOS-specific modules and home-manager
  - `darwin/` - Darwin-specific modules and home-manager
  - `shared/` - Cross-platform configurations (emacs, fish, git, etc.)
- `setup.sh` - A post-installation setup script that handles configuration tasks that can't easily be done purely through Nix
