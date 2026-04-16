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

-- Claude Code integration
-- Record an ID of a tab ringing a bell
local bell_tabs = {}
wezterm.on("bell", function(window, pane)
                       local tab = pane:tab()
                       if tab then
                           bell_tabs[tostring(tab:tab_id())] = true
                       end
end)
-- Visualize Claude Code events
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
                                   local tab_id = tostring(tab.tab_id)
                                   if tab.is_active then
                                       bell_tabs[tab_id] = nil
                                   end

                                   local title = tab.tab_title
                                   if not title or #title == 0 then
                                       local pane = tab.active_pane
                                       local cwd_uri = pane.current_working_dir
                                       if cwd_uri then
                                           local cwd = cwd_uri.file_path or tostring(cwd_uri)
                                           title = cwd:match("([^/]+)/?$") or cwd
                                       else
                                           title = pane.title
                                       end
                                   end

                                   local index = tab.tab_index + 1
                                   local marker = bell_tabs[tab_id] and "● " or ""
                                   title = "   " .. marker .. index .. ": " .. wezterm.truncate_right(title, max_width - 6) .. "   "

                                   return {
                                       { Text = title },
                                   }
end)


return config
