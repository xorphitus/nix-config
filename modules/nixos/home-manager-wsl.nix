{ config, pkgs, username, ... }:

{
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "25.05";

  imports =
    [
      ../shared/home-manager.nix
    ];
}
