{ pkgs, username, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
  system.primaryUser = "${username}";

  # Fonts
  fonts.packages = [
    pkgs.hackgen-nf-font
  ];

  # https://nix-darwin.github.io/nix-darwin/manual/

  system.keyboard.enableKeyMapping = true;

  system.keyboard.remapCapsLockToControl = true;

  # Use F1, F2, etc. keys as standard function keys.
  system.defaults.NSGlobalDomain."com.apple.keyboard.fnState" = true;

  # Whether to enable trackpad tap to click. The default is false.
  system.defaults.trackpad.Clicking = true;

  homebrew.enable = true;

  programs.fish.enable = true;
}
