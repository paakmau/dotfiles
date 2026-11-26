local wezterm = require 'wezterm'

local config = wezterm.config_builder()

if wezterm.target_triple:find("windows", 1, true) then
  config.default_prog = { "nu" }
end

config.font_size = 10
config.initial_rows = 56
config.initial_cols = 248
config.color_scheme = 'Gruvbox Dark (Gogh)'
config.scrollback_lines = 10000
config.canonicalize_pasted_newlines = "LineFeed"

config.quick_select_patterns = {
  -- Windows 路径
  [[\b[A-Za-z]:[\\/](?:[^\\/:*?"<>|\r\n]+[\\/])*[^\\/:*?"<>|\r\n]+]],
  -- 匹配带扩展名的文件名
  [[\b[\w.-]+\.[A-Za-z0-9]{1,12}\b]],
}

config.leader = {
  key = "a",
  mods = "CTRL",
}

config.keys = {
  {
    key = "a",
    mods = "LEADER|CTRL",
    action = wezterm.action.SendKey {
      key = "a",
      mods = "CTRL",
    },
  },
  {
    key = "v",
    mods = "LEADER",
    action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" },
  },
  {
    key = "s",
    mods = "LEADER",
    action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" },
  },
  {
    key = "q",
    mods = "LEADER",
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  {
    key = "h",
    mods = "LEADER",
    action = wezterm.action.ActivatePaneDirection "Left",
  },
  {
    key = "l",
    mods = "LEADER",
    action = wezterm.action.ActivatePaneDirection "Right",
  },
  {
    key = "k",
    mods = "LEADER",
    action = wezterm.action.ActivatePaneDirection "Up",
  },
  {
    key = "j",
    mods = "LEADER",
    action = wezterm.action.ActivatePaneDirection "Down",
  },
  {
    key = "z",
    mods = "LEADER",
    action = wezterm.action.TogglePaneZoomState,
  },
  {
    key = "a",
    mods = "LEADER",
    action = wezterm.action.ActivateKeyTable({
      name = "pane_adjust_mode",
      one_shot = false,
    }),
  },
  {
    key = ",",
    mods = "LEADER",
    action = wezterm.action.PromptInputLine {
      description = "Window title",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          local titles = wezterm.GLOBAL.window_titles or {}
          titles[tostring(window:window_id())] = line
          wezterm.GLOBAL.window_titles = titles
          window:mux_window():set_title(line) -- 仅用于触发 format-window-title 刷新
        end
      end),
    },
  },
}

config.key_tables = {
  pane_adjust_mode = {
    { key = "h", action = wezterm.action.AdjustPaneSize({ "Left", 1 }) },
    { key = "l", action = wezterm.action.AdjustPaneSize({ "Right", 1 }) },
    { key = "k", action = wezterm.action.AdjustPaneSize({ "Up", 1 }) },
    { key = "j", action = wezterm.action.AdjustPaneSize({ "Down", 1 }) },
    { key = "H", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
    { key = "L", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
    { key = "K", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
    { key = "J", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
    { key = "Escape", action = "PopKeyTable" },
  },
}

wezterm.on("format-window-title", function(tab)
  return (wezterm.GLOBAL.window_titles or {})[tostring(tab.window_id)] or ""
end)

return config
