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

    # Rofi
    ".config/rofi/config.rasi" = {
      source = ../config/rofi/config.rasi;
      target = ".config/rofi/config.rasi";
    };

    ".local/bin/rofi_system.sh" = {
      source = ../config/rofi/rofi_system.sh;
      target = ".local/bin/rofi_system.sh";
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

  systemd.user.services = {
    dropbox = {
      Unit = {
        Description = "Dropbox service";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.dropbox}/bin/dropbox";
        Restart = "on-failure";
      };
    };
  };

  xdg.desktopEntries.vivaldi = {
    name = "Vivaldi Wayland";
    exec = "vivaldi --ozone-platform=wayland --enable-wayland-ime %U";
    icon = "vivaldi";
    type = "Application";
    categories = [ "Network" "WebBrowser" ];
    mimeType = [ "application/pdf" "application/rdf+xml" "application/rss+xml" "application/xhtml+xml" "application/xhtml_xml" "application/xml" "image/gif" "image/jpeg" "image/png" "image/webp" "text/html" "text/xml" "x-scheme-handler/ftp" "x-scheme-handler/http" "x-scheme-handler/https" "x-scheme-handler/mailto"];
  };
}
