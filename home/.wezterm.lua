-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.font = wezterm.font 'JetBrainsMono Nerd Font'

config.color_scheme = 'catppuccin-mocha'

config.window_background_opacity = 0.95

config.hide_tab_bar_if_only_one_tab = true

return config
