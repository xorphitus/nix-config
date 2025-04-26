{ config, pkgs, ... }:

{
  home.username = "xorphitus";
  home.homeDirectory = "/home/xorphitus";

  home.stateVersion = "24.11";

  home.file = {
    # GPG
    ".gnupg/gpg-agent.conf" = {
      source = ../config/gnupg/gpg-agent.conf;
      target = ".gnupg/gpg-agent.conf";
    };

    ".config/environment.d/20-gnupg.conf" = {
      source = ../config/gnupg/env.conf;
      target = ".config/environment.d/20-gnupg.conf";
    };

    # Git
    ".gitconfig" = {
      source = ../config/git/gitconfig;
      target = ".gitconfig";
    };

    # Hyprland
    ".config/hypr/hyprland.conf" = {
      source = ../config/hypr/hyprland.conf;
      target = ".config/hypr/hyprland.conf";
    };

    # Fcitx
    ".config/environment.d/20-fcitx.conf" = {
      source = ../config/fcitx/env.conf;
      target = ".config/environment.d/20-fcitx.conf";
    };

    # Emacs
    ".emacs/init.el" = {
      source = ../config/emacs/init.el;
      target = ".emacs.d/init.el";
    };
  };
}
