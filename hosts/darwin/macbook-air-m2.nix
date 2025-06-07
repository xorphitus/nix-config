{ pkgs, username, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
  # Required for enabling Homebrew
  system.primaryUser = "${username}";

  environment.systemPackages = with pkgs; [
    # Only basic CLI tools
    # The others should be obtained with Homebrew
    bat
    fd
    fzf
    ghq
    htop
    jq
    lsd
    ripgrep
    starship
    zoxide
    gnupg
    cmigemo
    coreutils
  ];

  # https://nix-darwin.github.io/nix-darwin/manual/

  system.keyboard.remapCapsLockToControl = true;

  # Use F1, F2, etc. keys as standard function keys.
  system.defaults.NSGlobalDomain."com.apple.keyboard.fnState" = true;

  # Whether to enable trackpad tap to click. The default is false.
  system.defaults.trackpad.Clicking = true;

  homebrew.enable = true;

  programs.fish.enable = true;
}
