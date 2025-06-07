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
  ];

  # https://nix-darwin.github.io/nix-darwin/manual/

  homebrew.enable = true;

  programs.fish.enable = true;
}
