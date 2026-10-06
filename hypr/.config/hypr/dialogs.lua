-- Dialogs: float and center them, smaller than Omarchy's 875x600 float (which
-- fills most of a 1280x720 logical screen).
--
-- No border or rounding effects here, so dialogs keep general.border_size and
-- decoration.rounding from looknfeel.lua like every other window.
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

local dialog_size = { "(monitor_w*0.6)", "(monitor_h*0.65)" }

-- Modal popups from any app ("Save changes?", "Are you sure?", properties).
-- These size themselves to their content, so cap them instead of forcing a size.
o.window({ modal = true }, { float = true, center = true, max_size = { 900, 600 } })

-- File pickers and other dialogs, matched on the title they open with. Omarchy
-- only does this for a few apps (Nautilus, Sublime, OnlyOffice); this covers all.
o.window({
  title = "^(Open( .*)?|Save( .*)?|Select [Ff](ile|older).*|Choose .*|File Upload|.*wants to (open|save).*)$",
}, { float = true, center = true, size = dialog_size })

-- The GTK portal only ever shows dialogs; Omarchy already floats and centers
-- it at 875x600. Same rule, smaller size (the last matching size rule wins).
o.window("xdg-desktop-portal-gtk", { size = dialog_size })

-- yazi file picker opened by xdg-desktop-portal-termfilechooser (class set in
-- ~/.config/xdg-desktop-portal-termfilechooser/config).
o.window("yazi.filechooser", { float = true, center = true, size = { "(monitor_w*0.7)", "(monitor_h*0.75)" } })
