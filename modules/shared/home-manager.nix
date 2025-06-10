{ config, pkgs, ... }:

{
  # Git
  home.file.".gitconfig" = {
    source = ./config/git/gitconfig;
  };

  # SSH
  home.file.".ssh/config" = {
    source = ./config/ssh/config;
  };

  # Wezterm
  home.file.".config/wezterm/wezterm.lua" = {
    source = ./config/wezterm/wezterm.lua;
  };

  # Emacs
  home.file.".emacs.d/init.el" = {
    source = ./config/emacs/init.el;
  };

  # SKK
  home.file.".local/bin/update-skk-jisyos.sh" = {
    source = ./config/skk/update-dictionaries.sh;
    executable = true;
  };

  # Fish
  home.file.".config/fish/config.fish" = {
    source = ./config/fish/config.fish;
  };

  # GPG
  home.file.".gnupg/gpg-agent.conf" = {
    source = ./config/gnupg/gpg-agent.conf;
  };

  home.file.".gnupg/scdaemon.conf" = {
    source = ./config/gnupg/scdaemon.conf;
  };

  # Migemo dictionary
  home.file.".local/share/migemo" = {
    source = "${pkgs.cmigemo}/share/migemo";
  };

  # Enchant
  home.file.".config/enchant/enchant.ordering" = {
    source = ./config/enchant/enchant.ordering;
  };
}
