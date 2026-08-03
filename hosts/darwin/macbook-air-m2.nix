{ pkgs, inputs, username, ... }:

{
  imports = [
    ../../modules/shared/codex.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
  system.primaryUser = "${username}";

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    # Overlays from flake inputs
    inputs.herdr.overlays.default
    # direnv 2.37.1 fish tests are killed by macOS sandbox (SIGKILL)
    (_: prev: {
      direnv = prev.direnv.overrideAttrs (_: {
        doCheck = false;
      });
    })
  ];

  environment.systemPackages = with pkgs; [
    # Basic tools
    coreutils
    git
    gnupg
    iproute2mac
    mkalias
    # Convenient CLI tools
    bat
    delta
    fd
    fzf
    ghq
    herdr
    htop
    jq
    lsd
    ripgrep
    starship
    tmux # required for fzf-tmux
    yazi
    zoxide
    # Development
    gcc
    gnumake
    gh
    jujutsu
    jjui
    mise
    mermaid-cli
    shellcheck
    inputs.hunk.packages.${pkgs.stdenv.hostPlatform.system}.hunk
    # For Emacs
    cmigemo
    enchant
    # Tiling window manager
    aerospace
  ];

  # Fonts
  fonts.packages = [
    pkgs.hackgen-nf-font
  ];

  # https://nix-darwin.github.io/nix-darwin/manual/

  programs.fish.enable = true;

  # Keyboard
  system.keyboard.enableKeyMapping = true;

  system.keyboard.remapCapsLockToControl = true;

  ## Use F1, F2, etc. keys as standard function keys.
  system.defaults.NSGlobalDomain."com.apple.keyboard.fnState" = true;

  # Trackpad

  ## Whether to enable trackpad right click (two-finger tap/click).
  system.defaults.trackpad.TrackpadRightClick = true;

  ## Whether to enable trackpad tap to click. The default is false.
  system.defaults.trackpad.Clicking = true;

  ## Speed
  system.defaults.NSGlobalDomain."com.apple.trackpad.scaling" = 2.5;

  ## Disable natural scroll
  system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false;

  # Finder settings
  system.defaults.finder = {
    # Show extensions in their file names
    AppleShowAllExtensions = true;

    # Show hidden files
    AppleShowAllFiles = true;

    # Surpress warnings for file extension changes
    FXEnableExtensionChangeWarning = false;

    # Show file path at the bottom of Finder
    ShowPathbar = true;

    # Show file/directory status at the bottom of Finder
    ShowStatusBar = true;
  };

  # Dock settings
  system.defaults.dock = {
    autohide = true;

    show-recents = false;

    # Icon size in pixel
    tilesize = 36;

    # Icon magnification on mouse hover
    magnification = true;

    # Icon size on mouse hover
    largesize = 48;

    # Doc position
    orientation = "bottom";

    # Window minimization visual effect
    mineffect = "scale";

    # Disable application launch visual effect
    launchanim = false;
  };

  # Look and feel

  ## Dark mode
  system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";

  # Hot corner

  ## Assign bottom left to Lock Screen
  system.defaults.dock.wvous-bl-corner = 13;
}
