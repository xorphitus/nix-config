{ pkgs, ... }:

{
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
  ];

  # https://nix-darwin.github.io/nix-darwin/manual/

  homebrew.enable = true;

  programs.fish.enable = true;
}
