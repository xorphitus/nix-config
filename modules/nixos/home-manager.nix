{ config, pkgs, username, ... }:

{
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "24.11";

  imports =
    [
      ../shared/home-manager.nix
    ];

  home.packages = [
    # For the following dconf error:
    # https://github.com/nix-community/home-manager/issues/3113
    # For example, this issue prevents Rnote to save its configurations.
    pkgs.dconf
    # For GNOME Keyring
    # https://wiki.nixos.org/wiki/Secret_Service
    pkgs.gcr
  ];

  home.file = {
    # UWSM - set environmental variables
    ".config/uwsm/env" = {
      source = ./config/uwsm/env;
    };

    # Hyprland
    ".config/hypr/hyprland.conf" = {
      source = ./config/hypr/hyprland.conf;
    };

    ".local/bin/pin-workspaces.sh" = {
      source = ./config/hypr/pin-workspaces.sh;
      executable = true;
    };

    # Waybar
    ".config/waybar/config.jsonc" = {
      source = ./config/waybar/config.jsonc;
    };

    # SwayNotificatioNCenter
    ".config/swaync/config.json" = {
      source = ./config/swaync/config.json;
    };

    ".config/swaync/configSchema.json" = {
      source = ./config/swaync/configSchema.json;
    };

    ".config/swaync/style.css" = {
      source = ./config/swaync/style.css;
    };

    # Rofi
    ".config/rofi/config.rasi" = {
      source = ./config/rofi/config.rasi;
    };

    ".local/bin/rofi_system.sh" = {
      source = ./config/rofi/rofi_system.sh;
    };

    # Sound control scripts
    ".local/bin/volume.sh" = {
      source = ./config/sound/volume.sh;
      executable = true;
    };

    # Mise
    ".config/mise.toml" = {
      source = ./config/mise/mise.toml;
    };
  };

  # GNOME Keyring
  services.gnome-keyring.enable = true;

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

  # Open WebUI
  systemd.user.services.open-webui = {
    Unit = {
      Description = "Open WebUI";
      After = [ "network.target" ];
    };
    Service = {
      ExecStart = "${pkgs.open-webui}/bin/open-webui serve";
      Environment = [
        "DATA_DIR=%h/.local/share/open-webui"
        "OLLAMA_BASE_URL=http://localhost:11434"
        "PORT=8080"
      ];
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "default.target" ];
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
    source = ./config/home-cleaner/home-cleaner.sh;
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
    source = ./config/org-roam-backup/org-roam-backup.sh;
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
