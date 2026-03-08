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

  # Emacs
  home.file.".emacs.d/init.el" = {
    source = ./config/emacs/init.el;
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

  # Claude Code
  home.file.".claude/CLAUDE.md" = {
    source = ./config/claude/CLAUDE.md;
  };

  home.file.".claude/settings.json" = {
    source = ./config/claude/settings.json;
  };

  home.file.".claude/statusline.js" = {
    source = ./config/claude/statusline.js;
    executable = true;
  };

  home.file.".claude/notification.sh" = {
    source = ./config/claude/notification.sh;
    executable = true;
  };

  home.file.".local/bin/claude-ollama.sh" = {
    source = ./config/claude/claude-ollama.sh;
    executable = true;
  };
}
