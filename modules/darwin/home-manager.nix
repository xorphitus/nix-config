{ lib, pkgs, ... }:

{
  home.username = "xorphitus";
  home.homeDirectory = lib.mkForce "/Users/xorphitus";

  home.stateVersion = "24.11";

  imports =
    [
      ../shared/home-manager.nix
    ];
}
