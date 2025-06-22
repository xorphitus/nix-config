{ inputs, pkgs, lib, username, ... }:

{
  home.username = "${username}";
  # Workaround for https://github.com/nix-darwin/nix-darwin/issues/682
  home.homeDirectory = lib.mkForce "/Users/${username}";

  home.stateVersion = "24.11";

  imports =
    [
      ../shared/home-manager.nix
    ];

  nixpkgs = {
    overlays = [
      inputs.brew-nix.overlays.default
    ];
  };

  home.packages = with pkgs; [
    brewCasks.dropbox
    brewCasks.kindle
    brewCasks.keepassxc
    brewCasks.signal
    brewCasks.wezterm
    # Music
    (brewCasks.loopback.overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        url = builtins.head oldAttrs.src.urls;
        hash = "sha256-ctxUq5wLeELdV/Q3SZVOwIjYFXCFL0Cf6jEVf5rrQPk=";
      };
    }))
    brewCasks.musescore
    (brewCasks.spotify.overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        url = builtins.head oldAttrs.src.urls;
        hash = "sha256-msI8jSw/uKMJxQE9IaK48XkVVpJmq1aVJoaqyr7CB80=";
      };
    }))
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs.overrideAttrs (old: {
      # Apply emacs-plus's patches
      patches =
        (old.patches or [])
        ++ [
          # Fix OS window role (needed for window managers like yabai)
          # NOTE:  emacs-30/fix-window-role.patch is  a link to  emacs-28/fix-window-role.patch
          (pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/refs/heads/master/patches/emacs-28/fix-window-role.patch";
            sha256 = "sha256-+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
          })
          # Enable rounded window with no decoration
          (pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/refs/heads/master/patches/emacs-30/round-undecorated-frame.patch";
            sha256 = "sha256-uYIxNTyfbprx5mCqMNFVrBcLeo+8e21qmBE3lpcnd+4=";
          })
          # Make Emacs aware of OS-level light/dark mode
          (pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/refs/heads/master/patches/emacs-30/system-appearance.patch";
            sha256 = "sha256-3QLq91AQ6E921/W9nfDjdOUWR8YVsqBAT/W9c1woqAw=";
          })
        ];
    });
  };
}
