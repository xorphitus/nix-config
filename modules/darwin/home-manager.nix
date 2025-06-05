{ config, pkgs, ... }:

{
  home.username = "xorphitus";
  home.homeDirectory = "/home/xorphitus";

  home.stateVersion = "24.11";

  imports =
    [
      ../shared/home-manager.nix
    ];
}
