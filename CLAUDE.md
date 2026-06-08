# CLAUDE.md
## Overview

This is a personal NixOS/nix-darwin configuration repository using Nix Flakes. It provides configurations for:

- NixOS Linux desktop (x86_64-linux) - Main desktop with Hyprland, NVIDIA support, dual-boot Windows
- NixOS WSL (x86_64-linux) - WSL configuration
- NixOS VM (x86_64-linux) - Virtual machine configuration
- macOS (aarch64-darwin) - MacBook Air M2 configuration

## Fixing Configuration

This repo is the source of truth. Nix configs here are declarative and already
applied to the system, so files under `/nix/store` or `$HOME` are derived
artifacts — not where fixes belong.

When asked to fix something:

1. **Start here.** Read and reason about the Nix config in this repo as the
   primary option. Make changes here.
2. Only inspect applied configs under `/nix/store` or `$HOME` when the repo
   config already looks correct and you suspect a gap between what's declared
   here and what's actually running on the system.

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

## Testing

Nix:

```
statix check
deadnix
```

Fish:

```
fish --no-execute modules/shared/config/fish/config.fish
```

Emacs:

```
emacs --batch --eval '(byte-compile-file "modules/shared/config/emacs/init.el")'
```
