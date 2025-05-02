{ config, pkgs, ... }:

let migemoDictVersion = "v2021-05-07";

in {
  home.username = "xorphitus";
  home.homeDirectory = "/home/xorphitus";

  home.stateVersion = "24.11";

  home.file = {
    # Git
    ".gitconfig" = {
      source = ../config/git/gitconfig;
      target = ".gitconfig";
    };

    # SSH
    ".ssh/config" = {
      source = ../config/ssh/config;
      target = ".ssh/config";
    };

    # Hyprland
    ".config/hypr/hyprland.conf" = {
      source = ../config/hypr/hyprland.conf;
      target = ".config/hypr/hyprland.conf";
    };

    # Wezterm
    ".config/wezterm/wezterm.lua" = {
      source = ../config/wezterm/wezterm.lua;
      target = ".config/wezterm/wezterm.lua";
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
    ".local/bin/update-skk-jisyos.sh" = {
      source = ../config/skk/update-dictionaries.sh;
      target = ".local/bin/update-skk-jisyos.sh";
      executable = true;
    };

    # Migemo dictionary
    ".local/share/migemo" = {
      source = "${pkgs.cmigemo}/share/migemo";
      target = ".local/share/migemo";
    };
  };

  # Fish
  home.file.".config/fish/config.fish" = {
    source = ../config/fish/config.fish;
    target = ".config/fish/config.fish";
  };

  # GPG
  home.file.".gnupg/gpg-agent.conf" = {
    source = ../config/gnupg/gpg-agent.conf;
    target = ".gnupg/gpg-agent.conf";
  };

  home.file.".gnupg/scdaemon.conf" = {
    source = ../config/gnupg/scdaemon.conf;
    target = ".gnupg/scdaemon.conf";
  };

  home.file.".local/bin/set-gnupg-env.sh" = {
    source = ../config/gnupg/set-gnupg-env.sh;
    target = ".local/bin/set-gnupg-env.sh";
    executable = true;
  };

  systemd.user.services.set-gnupg-env = {
    Unit = {
      Description = "Set environment variables for GnuPG";
      After = [ "default.target" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = "${config.home.homeDirectory}/.local/bin/set-gnupg-env.sh";
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  # Dropbox
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

  # Vivaldi
  xdg.desktopEntries.vivaldi = {
    name = "Vivaldi Wayland";
    exec = "vivaldi --ozone-platform=wayland --enable-wayland-ime %U";
    icon = "vivaldi";
    type = "Application";
    categories = [ "Network" "WebBrowser" ];
    mimeType = [ "application/pdf" "application/rdf+xml" "application/rss+xml" "application/xhtml+xml" "application/xhtml_xml" "application/xml" "image/gif" "image/jpeg" "image/png" "image/webp" "text/html" "text/xml" "x-scheme-handler/ftp" "x-scheme-handler/http" "x-scheme-handler/https" "x-scheme-handler/mailto"];
  };

  # VOICEVOX
  systemd.user.services.voicevox = {
    Unit = {
      Description = "VOICEVOX";
      After = [ "network.target" ];
    };
    Service = {
      ExecStart = "/run/current-system/sw/bin/docker run --rm --gpus all -p '127.0.0.1:50021:50021' voicevox/voicevox_engine:nvidia-latest";
      Restart = "always";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Home cleaner
  home.file.".local/bin/home-cleaner.sh" = {
    source = ../config/home-cleaner/home-cleaner.sh;
    target = ".local/bin/home-cleaner.sh";
    executable = true;
  };

  systemd.user.services.home-cleaner = {
    Unit = {
      Description = "Home cleaner for deleting old files";
    };
    Service = {
      ExecStart = "${config.home.homeDirectory}/.local/bin/home-cleaner.sh 30";
      Type = "oneshot";
    };
  };

  systemd.user.timers.home-cleaner = {
    Unit = {
      Description = "Timer for home cleaner";
    };
    Timer = {
      OnCalendar = "*-*-* *:00:00";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  # Org-roam auto backup
  home.file.".local/bin/org-roam-backup.sh" = {
    source = ../config/org-roam-backup/org-roam-backup.sh;
    target = ".local/bin/org-roam-backup.sh";
    executable = true;
  };

  systemd.user.services.org-roam-backup = {
    Unit = {
      Description = "Org-roam backup";
    };
    Service = {
      ExecStart = "${config.home.homeDirectory}/.local/bin/org-roam-backup.sh";
      Type = "oneshot";
    };
  };

  systemd.user.timers.org-roam-backup = {
    Unit = {
      Description = "Timer for Org-roam backup";
    };
    Timer = {
      OnCalendar = "*-*-* *:00:00";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
