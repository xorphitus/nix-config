{ config, ... }:

{
  # Git
  home.file.".gitconfig" = {
    source = ./config/git/gitconfig;
    target = ".gitconfig";
  };

  # SSH
  home.file.".ssh/config" = {
    source = ./config/ssh/config;
    target = ".ssh/config";
  };

  # Wezterm
  home.file.".config/wezterm/wezterm.lua" = {
    source = ./config/wezterm/wezterm.lua;
    target = ".config/wezterm/wezterm.lua";
  };

  # Emacs
  home.file.".emacs/init.el" = {
    source = ./config/emacs/init.el;
    target = ".emacs.d/init.el";
  };

  # SKK
  home.file.".local/bin/update-skk-jisyos.sh" = {
    source = ./config/skk/update-dictionaries.sh;
    target = ".local/bin/update-skk-jisyos.sh";
    executable = true;
  };
  # Fish
  home.file.".config/fish/config.fish" = {
    source = ./config/fish/config.fish;
    target = ".config/fish/config.fish";
  };

  # GPG
  home.file.".gnupg/gpg-agent.conf" = {
    source = ./config/gnupg/gpg-agent.conf;
    target = ".gnupg/gpg-agent.conf";
  };

  home.file.".gnupg/scdaemon.conf" = {
    source = ./config/gnupg/scdaemon.conf;
    target = ".gnupg/scdaemon.conf";
  };
}
