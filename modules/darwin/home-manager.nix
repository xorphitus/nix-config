{ pkgs, lib, username, ... }:

{
  home.username = "${username}";
  # Workaround for https://github.com/nix-darwin/nix-darwin/issues/682
  home.homeDirectory = lib.mkForce "/Users/${username}";

  home.stateVersion = "24.11";

  imports =
    [
      ../shared/home-manager.nix
    ];
}
