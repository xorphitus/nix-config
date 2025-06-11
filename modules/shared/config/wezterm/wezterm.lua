local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local isDarwin = os.getenv("HOME"):match("^/Users")

if isDarwin then
  config.default_prog = { '/run/current-system/sw/bin/fish', '-l' }
else
  -- Prevent Wezterm to automatically override SSH_AUTH_SOCK when it's set.
  -- As of March 2025, this configuration is available only in a nightly build.
  -- Therefore, unfortunatelly, this is not working, but just for preparation.
  local SSH_AUTH_SOCK = os.getenv 'SSH_AUTH_SOCK'
  if SSH_AUTH_SOCK ~= nil and SSH_AUTH_SOCK ~= '' then
    config.default_ssh_auth_sock = SSH_AUTH_SOCK
  end
end

config.font = wezterm.font_with_fallback {
  'HackGen35 Console NF',
  'Ricty Discord Nerd Font',
  'Ricty Discord',
}
config.window_background_opacity = 0.95
config.use_ime = true

return config
