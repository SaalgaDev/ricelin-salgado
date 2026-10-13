hl.config({
    input = {
        -- "de" trazia Z e Y trocados em relacao ao US. "us" volta as posicoes do
-- teclado US e "alt-intl" como variante mantem os acentos no AltGr.
-- Atencao: o Hyprland usa kb_layout e kb_variant separados; "us,alt-intl" na
-- linha do kb_layout quebra a compilacao do keymap e deixa o teclado sem layout.
kb_layout          = "us",
kb_variant         = "alt-intl",
        follow_mouse       = 1,
        sensitivity        = 0,
        accel_profile      = "flat",
        repeat_rate        = 40,
        repeat_delay       = 400,
        numlock_by_default = false,
        touchpad = {
            natural_scroll = true,
        },
    },
    cursor = {
        no_hardware_cursors = true,
    },
    binds = {
        scroll_event_delay = 40,
    },
})
