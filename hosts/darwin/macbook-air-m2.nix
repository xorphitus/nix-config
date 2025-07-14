{ pkgs, username, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
  system.primaryUser = "${username}";

  environment.systemPackages = with pkgs; [
    # Basic tools
    coreutils
    git
    gnupg
    iproute2mac
    mkalias
    # Convenient CLI tools
    bat
    fd
    fzf
    ghq
    htop
    jq
    lsd
    ripgrep
    starship
    tmux # required for fzf-tmux
    zoxide
    # Development
    gcc
    gnumake
    jujutsu
    mise
    mermaid-cli
    # For Emacs
    cmigemo
    enchant
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
}
