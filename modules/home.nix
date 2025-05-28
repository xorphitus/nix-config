{ config, pkgs, ... }:

let migemoDictVersion = "v2021-05-07";

in {
  home.username = "xorphitus";
  home.homeDirectory = "/home/xorphitus";

  home.stateVersion = "24.11";

  # For the following dconf error:
  # https://github.com/nix-community/home-manager/issues/3113
  # For example, this issue prevents Rnote to save its configurations.
  home.packages = [ pkgs.dconf ];

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

    # Waybar
    ".config/waybar/config.jsonc" = {
      source = ../config/waybar/config.jsonc;
      target = ".config/waybar/config.jsonc";
    };

    # SwayNotificatioNCenter
    ".config/swaync/config.json" = {
      source = ../config/swaync/config.json;
      target = ".config/swaync/config.json";
    };

    ".config/swaync/configSchema.json" = {
      source = ../config/swaync/configSchema.json;
      target = ".config/swaync/configSchema.json";
    };

    ".config/swaync/style.css" = {
      source = ../config/swaync/style.css;
      target = ".config/swaync/style.css";
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

    # Sound control scripts
    ".local/bin/volume.sh" = {
      source = ../config/sound/volume.sh;
      target = ".local/bin/volume.sh";
      executable = true;
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

  # Syncthing
  services = {
    syncthing = {
      enable = true;
    };
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

  # Document: https://nix-community.github.io/home-manager/options.xhtml#opt-gtk
  gtk = {
    enable = true;
    theme = {
      package = pkgs.nordic;
      name = "Nordic";
    };
    iconTheme = {
      package = pkgs.tela-icon-theme;
      name = "Tela-nord-dark";
    };
    cursorTheme = {
      package = pkgs.volantes-cursors;
      name = "volantes_cursors";
      size = 32;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };
}
