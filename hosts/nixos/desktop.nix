# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, username, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./desktop_hardware.nix
    ];

  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;

    systemd-boot = {
      enable = true;

      configurationLimit = 10;

      windows = {
        "windows" =
          let
            # To determine the name of the windows boot drive, boot into edk2 first, then run
            # `map -c` to get drive aliases, and try out running `FS1:`, then `ls EFI` to check
            # which alias corresponds to which EFI partition.
            boot-drive = "FS1";
          in
            {
              title = "Windows";
              efiDeviceHandle = boot-drive;
              sortKey = "y_windows";
            };
      };

      edk2-uefi-shell.enable = true;
      edk2-uefi-shell.sortKey = "z_edk2";
    };
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "C.UTF-8";
    LC_IDENTIFICATION = "C.UTF-8";
    LC_MEASUREMENT = "C.UTF-8";
    LC_MONETARY = "C.UTF-8";
    LC_NAME = "C.UTF-8";
    LC_NUMERIC = "C.UTF-8";
    LC_PAPER = "C.UTF-8";
    LC_TELEPHONE = "C.UTF-8";
    LC_TIME = "C.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Fish installation
  programs.fish.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "${username}'s desktop PC";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    coreutils-full
    file
    dig
    gcc
    git
    unzip
    usbutils
    # CLI
    bat
    bottom
    delta
    dust
    hexyl
    hyperfine
    lnav
    fd
    fzf
    ghq
    jq
    lsd
    nvtopPackages.nvidia
    procs
    ripgrep
    starship
    tmux # required for fzf-tmux
    zoxide
    # Sound
    alsa-utils
    playerctl
    pavucontrol # GUI
    # Development
    claude-code
    jujutsu
    gnumake
    mise
    mermaid-cli
    podman-compose
    (pkgs.callPackage ../../modules/nixos/devtoys-cli.nix {})
    # GUI
    hyprlock
    waybar
    code-cursor
    firefox
    keepassxc
    meld
    musescore
    pcmanfm
    rnote
    rofi-wayland
    signal-desktop
    spotify
    swaynotificationcenter
    tlaplusToolbox
    vivaldi
    wezterm
    # Emacs
    emacs-pgtk # -pgtk is required for Wayland
    cmigemo
    enchant
    nuspell
    hunspellDicts.en_US-large
    wl-clipboard # Required to fix broken clipboard
    # Immersed
    immersed
    egl-wayland
    xdg-desktop-portal-hyprland
    # GnuPG
    gnupg
    pinentry
    pcsc-tools
    pcsclite
    # YubiKey
    pam_u2f
    yubikey-personalization-gui
    yubioath-flutter
    # Etc
    libnotify
  ];

  # Fonts
  fonts.packages = [
    pkgs.hackgen-nf-font
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-cjk-serif
    pkgs.noto-fonts-color-emoji
    pkgs.font-awesome
  ];

  # GnuPG and smartcard
  services.pcscd.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  nixpkgs.config.allowBroken = true;
  boot.kernelModules = [
    "r8125"
    # Virtual camera for Immersed
    "v4l2loopback"
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    r8125
    # Virtual camera for Immersed
    v4l2loopback
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # getty is used for bypassing user login window compositor selection.
  # It's because this machine is used by a only single human user and the
  # login process is protected by the LUKS passphrase input process.
  # Login shell profile is expected to execute compositor after auto login.
  # Greeetd can directly execute compositor, e.g., Hyprland, without login shell,
  # but it couldn't work  with uwsm, which can provide environmental variables.
  services.getty.autologinOnce = true;
  services.getty.autologinUser = "${username}";

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-mozc
      ];
    };
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Podman
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  hardware.nvidia-container-toolkit.enable = true;

  environment.etc = {
    "containers/registries.conf.d/01-dockerhub.conf".text = ''
      unqualified-search-registries=["docker.io"]
    '';

    # Generated with the following
    # $ nix-shell -p nvidia-container-toolkit
    # $ nvidia-ctk cdi generate --output ./desktop_nvidia.yaml
    "cdi/nvidia.yaml".source = ./desktop_nvidia.yaml;
  };

  # Ollama
  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };

  # Hyprlock
  security.pam.services.hyprlock = {
    u2fAuth = true;
  };

  # Enable PCManFM USB automounting
  services.gvfs.enable = true;

  # Waydroid
  virtualisation.waydroid.enable = true;

  # /etc/hosts
  networking.extraHosts =
    ''
    # Don't access time eaters
    127.0.0.1 minesweeper.online
    127.0.0.1 captown.capcom.com
    127.0.0.1 www.play-minesweeper.com
    127.0.0.1 cardgames.io
    127.0.0.1 minesweeperonline.com
    127.0.0.1 www.247minesweeper.com
    127.0.0.1 poki.com
    127.0.0.1 mineswifter.com
    127.0.0.1 danielben.itch.io
    127.0.0.1 www.studiok-i.net
    127.0.0.1 syougi.qinoa.com
    127.0.0.1 lishogi.org
    127.0.0.1 www.afsgames.com
    127.0.0.1 sdin.jp
    127.0.0.1 tetr.io
    127.0.0.1 play.tetris.com
    127.0.0.1 unityroom.com
    '';

  # Enable printers
  services.printing.enable = true;
  services.printing.drivers = [
    (pkgs.callPackage ../../modules/nixos/cndrvcups-lt.nix {})
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # VOICEVOX Editor (Electron)
      glib
      nss
      nspr
      dbus
      atk
      gtk3
      pango
      cairo
      xorg.libX11
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      libgbm
      expat
      xorg.libxcb
      libxkbcommon
      alsa-lib
      # Printer
      cups
    ];
  };
}
