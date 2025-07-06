# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal NixOS/nix-darwin configuration repository using Nix Flakes. It provides configurations for:
- **NixOS Linux desktop** (x86_64-linux) - Main desktop with Hyprland, NVIDIA support, dual-boot Windows
- **NixOS VM** (x86_64-linux) - Virtual machine configuration
- **macOS** (aarch64-darwin) - MacBook Air M2 configuration

## Key Commands

### System Management

**NixOS (rebuild system configuration):**
```bash
sudo nixos-rebuild switch --flake .#desktop
sudo nixos-rebuild switch --flake .#vm
```

**Darwin (rebuild system configuration):**
```bash
darwin-rebuild switch --flake .#macbook-air-m2
```

**Update flake inputs:**
```bash
nix flake update
```

**Development tools (via mise):**
```bash
mise install    # Install all tools defined in mise.toml
mise use -g python@3.12  # Set global Python version
```

### Setup Commands

**Fish shell plugins:**
```bash
setup-fish-env
```

**Emacs setup:**
```bash
~/.local/bin/update-skk-jisyos.sh
# Then in Emacs: M-x all-the-icons-install-fonts
```

**macOS Spotlight aliases:**
```bash
./darwinAliases.sh
```

## Architecture

### Flake Structure
- `flake.nix` - Main flake configuration with inputs (nixpkgs, home-manager, nix-darwin, brew-nix)
- `hosts/` - Host-specific configurations
  - `nixos/` - NixOS configurations (desktop, vm, common)
  - `darwin/` - macOS configurations
- `modules/` - Shared configuration modules
  - `nixos/` - NixOS-specific modules and home-manager
  - `darwin/` - Darwin-specific modules and home-manager
  - `shared/` - Cross-platform configurations (emacs, fish, git, etc.)

### Key Features
- **Desktop Environment**: Hyprland (Wayland) with waybar, rofi, hyprlock
- **Development**: mise for tool management, podman for containers, jujutsu for VCS
- **Applications**: Emacs, Firefox, Cursor, Spotify, Signal, KeePassXC
- **Security**: YubiKey support, U2F authentication for hyprlock
- **Fonts**: HackGen Nerd Font, Noto CJK fonts with emoji support

### Configuration Files
Important configuration files are managed in `modules/shared/config/`:
- `emacs/init.el` - Emacs configuration
- `fish/config.fish` - Fish shell configuration
- `git/gitconfig` - Git configuration
- `hypr/hyprland.conf` - Hyprland window manager
- `waybar/config.jsonc` - Waybar configuration
- `wezterm/wezterm.lua` - Terminal emulator configuration

### Platform Differences
- **NixOS**: Full system configuration with hardware-specific settings, NVIDIA support, dual-boot
- **Darwin**: System preferences, keyboard/trackpad settings, homebrew integration via brew-nix
- **Shared**: Home-manager configurations for applications, dotfiles, and user environment

## Development Notes

- Uses Nix Flakes with pinned inputs for reproducibility
- Home-manager integrated for user environment management
- Mise (formerly rtx) for language runtime management
- Podman with Docker compatibility for containerization
- Fish shell with starship prompt and various CLI tools (bat, fd, fzf, ripgrep, etc.)