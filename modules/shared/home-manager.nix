{ pkgs, ... }:

{
  # Git
  home.file.".gitconfig" = {
    source = ./config/git/gitconfig;
  };

  home.file.".config/git/ignore" = {
    source = ./config/git/ignore;
  };

  # Jujutsu
  home.file.".config/jj/config.toml" = {
    source = ./config/jujutsu/config.toml;
  };

  # SSH
  home.file.".ssh/config" = {
    source = ./config/ssh/config;
  };

  # Wezterm
  home.file.".config/wezterm/wezterm.lua" = {
    source = ./config/wezterm/wezterm.lua;
  };

  # Herdr
  home.file.".config/herdr/config.toml" = {
    source = ./config/herdr/config.toml;
  };

  # Emacs
  home.file.".emacs.d/init.el" = {
    source = ./config/emacs/init.el;
  };

  # Fish
  programs.fish = {
    enable = true;
    shellInit = builtins.readFile ./config/fish/config.fish;
    plugins = [
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      {
        name = "ghq_cd_keybind";
        src = pkgs.fetchFromGitHub {
          owner = "masa0x80";
          repo = "ghq_cd_keybind.fish";
          rev = "c289d87b270ff23de27b6ca3d59dccf38810bc26";
          hash = "sha256-vaosyDFvrkXD6hQCXf3+kCNLKA21+GfS57E5fPv0Lj4=";
        };
      }
    ];
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

  # Claude Code
  home.file.".claude/CLAUDE.md" = {
    source = ./config/claude/CLAUDE.md;
  };

  home.file.".claude/settings.json" = {
    source = ./config/claude/settings.json;
  };

  home.file.".claude/statusline.sh" = {
    source = ./config/claude/statusline.sh;
    executable = true;
  };

  home.file.".claude/notification.sh" = {
    source = ./config/claude/notification.sh;
    executable = true;
  };

  home.file.".claude/enforce-commands.sh" = {
    source = ./config/claude/enforce-commands.sh;
    executable = true;
  };

  home.file.".claude/skills" = {
    source = ./config/claude/skills;
    recursive = true;
  };
}
