-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
-- hl.config({
--   general = {
--     -- No gaps between windows or borders.
--     gaps_in = 0,
--     gaps_out = 0,
--     border_size = 0,
--
--     -- Change to niri-like side-scrolling layout.
--     layout = "scrolling",
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
-- hl.config({
--   decoration = {
--     -- Use round window corners.
--     rounding = 8,
--
--     -- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed).
--     dim_inactive = true,
--     dim_strength = 0.15,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
-- hl.config({
--   animations = {
--     -- Disable all animations.
--     enabled = false,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
-- hl.config({
--   layout = {
--     -- Avoid overly wide single-window layouts on wide screens.
--     single_window_aspect_ratio = { 1, 1 },
--   },
-- })

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- hl.config({
--   scrolling = {
--     -- See only one column per screen instead of two.
--     column_width = 0.97,
--   },
-- })

-- ── Custom look'n'feel ──────────────────────────────────────────────

hl.config({
  general = {
    gaps_in = 3,
    gaps_out = 6,
    border_size = 1,
  },

  decoration = {
    rounding = 5,

    -- Subtle blur (only visible behind transparent windows/layers).
    blur = {
      enabled = true,
      size = 3,
      passes = 1,
      vibrancy = 0.17,
    },
  },
})

-- Smooth, snappy animations. Speed is in ds (1 = 100ms); lower = faster.
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("snappyQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 4, bezier = "snappyQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4, bezier = "snappyQuint", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "snappyQuint", style = "popin 80%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "snappyQuint" })
hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "snappyQuint" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "snappyQuint", style = "slide" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.5, bezier = "snappyQuint" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.2, bezier = "snappyQuint" })
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "snappyQuint" })
