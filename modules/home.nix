{ config, pkgs, ... }:

let migemoDictVersion = "v2021-05-07";

in {
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

    # SKK
    ".local/bin/update-skk-jisyo.sh" = {
      source = ../config/skk/update-skk-jisyo.sh;
      target = ".local/bin/update-skk-jisyo.sh";
      executable = true;
    };

    # Migemo dictionary
    ".local/share/migemo" = {
      source = "${pkgs.cmigemo}/share/migemo";
      target = ".local/share/migemo";
    };
  };
}
