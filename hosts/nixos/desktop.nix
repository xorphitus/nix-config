# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.xorphitus = {
    isNormalUser = true;
    description = "Xorphitus's desktop PC";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    gcc
    emacs
    cmigemo # for Emacs
    # CLI
    bat
    fd
    fzf
    ghq
    htop
    lsd
    nvtopPackages.nvidia
    ripgrep
    toybox # for bascic utilities
    zoxide
    # Development
    mise
    # GUI
    hyprland
    hyprlock
    waybar
    rofi-wayland
    wezterm
    vivaldi
    firefox
    keepassxc
    pavucontrol
    alsa-utils
    spotify
    # GnuPG
    gnupg
    pinentry
    pcsc-tools
    pcsclite

    # Font
    (pkgs.stdenv.mkDerivation {
      pname = "hackgen-nf-font";
      version = "2.10.0";
      src = pkgs.fetchzip {
        url = "https://github.com/yuru7/HackGen/releases/download/v2.10.0/HackGen_NF_v2.10.0.zip";
        sha256 = "111fjcm0lcb2bfhddpx1503vk12va5j1241dfia9pjs86cirnj4z";
      };
      installPhase = ''
        mkdir -p $out/share/fonts/truetype
        cp *.ttf $out/share/fonts/truetype/
      '';
    })
  ];


  fonts.fonts = [
    pkgs.hackgen-nf-font
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
  boot.kernelModules = [ "r8125" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    r8125
  ];

  # For Chromium browsers including Vivaldi
  programs.xwayland.enable = true;

  services.xserver.enable = true;
  services.displayManager.sddm.enable = false;

  services.greetd.enable = true;
  services.greetd.settings.default_session = {
    command = "Hyprland";
    user = "xorphitus";
  };

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-mozc
    ];
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

  environment.etc."containers/registries.conf.d/01-dockerhub.conf".text = ''
    unqualified-search-registries=["docker.io"]
  '';

  # Ollama
  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };
}
