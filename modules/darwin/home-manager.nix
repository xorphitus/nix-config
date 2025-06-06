{ lib, pkgs, username, ... }:

{
  home.username = "${username}";
  home.homeDirectory = lib.mkForce "/Users/${username}";

  home.stateVersion = "24.11";

  imports =
    [
      ../shared/home-manager.nix
    ];
}
