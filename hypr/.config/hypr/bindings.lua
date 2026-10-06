-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Super+F maximizes (fullscreen mode 1: keeps the bar and gaps) instead of
-- true fullscreen. Super+F was "Full screen".
hl.unbind("SUPER + F")
o.bind("SUPER + F", "Maximize", hl.dsp.window.fullscreen({ mode = "maximized" }))

-- True fullscreen moves to Super+Shift+F. Super+Shift+F was "File manager"
-- (now yazi on Super+Alt+Shift+F, below).
hl.unbind("SUPER + SHIFT + F")
o.bind("SUPER + SHIFT + F", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

-- File manager: yazi in Ghostty instead of Nautilus (Nautilus stays installed).
-- Super+Alt+Shift+F was "File manager (cwd)" in Nautilus; it still opens in the
-- focused terminal's directory (or ~ when the focused window isn't a terminal).
hl.unbind("SUPER + ALT + SHIFT + F")
o.bind("SUPER + ALT + SHIFT + F", "File manager (cwd)", { launch = 'ghostty -e yazi "$(omarchy-cmd-terminal-cwd)"' })

-- GUI file manager (Nautilus) on Super+E.
o.bind("SUPER + E", "Files", { omarchy = "nautilus" })
