###########################################################
# login process
function _start_compositor
  # Available only in TTY1
  test (tty) = "/dev/tty1"; or return

  type uwsm > /dev/null; or begin
    echo "uwsm is not available. Falling back to direct Hyprland launch."
    Hyprland
  end

  if uwsm check may-start
    exec uwsm start hyprland-uwsm.desktop
  else
    echo "uwsm check failed. Falling back to direct Hyprland launch."
    uwsm check may-start -v
    Hyprland
  end
end

# Execute only once in login
if status is-login
  if not set -q __sourced_profile
    set -x __sourced_profile 1
    if test (uname) = Linux
      _start_compositor
    end
  else
    set -e __sourced_profile
  end
end

###########################################################
# general
set -x EDITOR nano
set -x ALTERNATE_EDITOR emacs
set -x GPG_TTY (tty)
# Propabably can delete this when Wezterm release builds supports default_ssh_auth_sock
# because uwsm/env should have this instead. See Wezterm's configuration about the details.
set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)

# disable greeting
set -U fish_greeting

###########################################################
# prompto
starship init fish | source

###########################################################
# fzf
set -x FZF_TMUX 1
set -x FZF_TMUX_HEIGHT 50%

function jw
  set prefix '.wt'
  set repo_root (jj workspace root | sed -s "s/\/$prefix\/.*//")
  set target (jj workspace list | fzf | cut -d ':' -f 1)

  if test $target = "default"
    cd $repo_root
  else
    cd "$repo_root/$prefix/$target"
  end
end

###########################################################
# path
set -x PATH  ~/.local/bin/ $PATH

switch (uname)
  case Darwin
    set -x PATH /usr/local/share/git-core/contrib/diff-highlight $PATH
end

###########################################################
# less
set -x PAGER 'less'
set -x LESS '-iMR --LONG-PROMPT'

###########################################################
# Mise
type mise > /dev/null; and mise activate fish | source

###########################################################
# other utilities
# This environmental variable is required when `ls` is an
# alias of `lsd`. Otherwise their incompatibility causes
# an error.
set -x _ZO_FZF_OPTS '--preview="ls -F"'
zoxide init fish | source

###########################################################
# aliases
alias ls='lsd'
alias ack='rg'
alias l='ls'
alias lt='ls --tree'

###########################################################
# functions
function psg
  ps u | head -n 1
  set arg $argv[1]
  ps aux | grep -i $arg | grep -v "grep $arg"
end

function setup-fish-env
  if not type -q fisher
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
  end

  set -l required_plugins jethrokuan/fzf masa0x80/ghq_cd_keybind.fish
  for plugin in $required_plugins
    if not fisher list | grep -q $plugin
      fisher install $plugin
    end
  end

  fisher update
end

# Fish version ssh-agent
# `eval (ssh-agent-fish)`
function ssh-agent-fish
  # Once I applied `sed` to `ssh-agent` stdout, but actually I don't need that.
  ssh-agent -c
end

# Extended EmacsClient
# * with arguments: normal emacsclient
# * without arguments: Piping stdout to an Emacs buffer using emacsclient
#   * e.g. `$ echo foo | e`
#
# https://www.emacswiki.org/emacs/EmacsClient#toc45
# http://d.hatena.ne.jp/kitokitoki/20111225/p4
function e
  if test (uname) = Linux
    # Auto focus to Emacs window
    # see: http://syohex.hatenablog.com/entry/20110127/1296141148
    set emacs_wid (wmctrl -l | grep 'Emacs at '(hostname) | awk '{print $1}')
    if test -n $emacs_wid
      wmctrl -i -a $emacs_wid
    end
  end

  switch (count $argv)
    case 0
      set tmp (mktemp /tmp/emacsstdinXXXXXX)
      set elisp "(let ((b (create-file-buffer \"*stdin*\"))) (switch-to-buffer b) (insert-file-contents \"$tmp\") (delete-file \"$tmp\"))"
      cat > $tmp
      if not emacsclient -a /usr/bin/false -e $elisp > /dev/null 2>&1
        emacs -e $elisp &
      end
    case '*'
      emacsclient -a emacs -n $argv > /dev/null 2>&1 &
  end
end

# display shell buffer in Emacs
function es
  tmux capture-pane -S -10000\; show-buffer | e
end

# Secret handling with Pass
alias mutt="mutt -e 'set imap_pass='(pass email/imap)"

# Emacs Tramp
# It requires very simple prompt for parse
# Tramp set TERM as dumb by default
if test "$TERM" = "dumb"
  function fish_prompt
    echo "\$ "
  end

  function fish_right_prompt; end
  function fish_greeting; end
  function fish_title; end
end

#####################################
# Terminal Emulator Specific Settings

# Kitty
if test "$TERM" = "xterm-kitty"
  kitty + complete setup fish | source
  alias icat="kitty +kitten icat --align=left"
  alias d="kitty +kitten diff"
  # Prevent SSH issues on Kitty
  alias ssh="kitty +kitten ssh"
  set -x TERM 'xterm-256color'
end

# Mac iTerm2
test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
