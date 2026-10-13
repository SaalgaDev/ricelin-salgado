-- Portable single-monitor config: lets Hyprland pick whatever is plugged in,
-- at its preferred mode, scale 1.
--
-- If you have a fixed layout (two screens, a specific position, a different
-- scale), replace this file with your own. Run `hyprctl monitors` to read the
-- output names and resolutions, then copy the shape of
-- monitors.local.lua.example, which is this machine's real layout.
--
-- This file is in the Ricelin PRESERVED list, so `ricelin update` never
-- overwrites it.
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})