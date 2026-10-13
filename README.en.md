<div align="center">

# ricelin-salgado

**My personal layer over [Ricelin](https://github.com/Gakuseei/Ricelin)** — Hyprland
configured in Lua, shell in Quickshell, Ghostty terminal, palette pulled from the
wallpaper.

[**Credits and licence**](CREDITS.md) · [Português](README.md)

</div>

---

## ⚠️ Credits first

This repository is **not a rice built from scratch**. It is a personal layer on top
of **[Ricelin](https://github.com/Gakuseei/Ricelin)** by **Gakuseei**, MIT, © 2026.

Everything you see on screen — the Lua compositor config, the pill that morphs into
a calendar/mixer/wallpaper picker, the lock screen, `rishot`, the wallpaper palette
engine, the scripts, the installer — is Gakuseei's work. What lives here are my
adjustments: the keybinds, the keyboard layout, the Qt theme fix and the `Alt+F3`
script.

If you want the complete rice, use the original repository:

```sh
curl -fsSL https://raw.githubusercontent.com/Gakuseei/Ricelin/main/install.sh | bash -s -- --quickstart
```

Installed against revision `2109754` (2026-09-26).

---

## What this is

A rice in two layers:

```
┌─ ricelin-salgado (this repo) ───────────────────────────┐
│  overlay/hypr/modules/binds.lua       keybinds         │
│  overlay/hypr/modules/monitors.lua    displays         │
│  overlay/hypr/modules/input.lua       keyboard         │
│  overlay/hypr/modules/env.lua         Qt theme         │
│  overlay/hypr/scripts/show-desktop.sh  Alt+F3          │
│  overlay/extras/qt6ct/                palette for Qt   │
└───────────────────────┬───────────────────────────────┘
                        │  install.sh lays it on top
                        ▼
┌─ Ricelin (Gakuseei) ───────────────────────────────────┐
│  hyprland.lua + modules/*.lua      compositor in Lua   │
│  quickshell/pill + lock + launcher  Quickshell shell   │
│  ghostty, fish, fastfetch, rishot                      │
│  wallpaper.sh, wallcolors.py, matugen                 │
└────────────────────────────────────────────────────────┘
```

That split has a practical payoff: `ricelin update` keeps working without
undoing anything of mine, because every overlay file is in the rice installer's
`PRESERVED` list — the updater three-way merges them instead of overwriting them.

## Install

```sh
git clone https://github.com/SaalgaDev/ricelin-salgado.git
cd ricelin-salgado
./install.sh
```

Or in one line:

```sh
git clone https://github.com/SaalgaDev/ricelin-salgado.git && \
  ricelin-salgado/install.sh
```

`install.sh` does two things, in order:

1. runs the official Ricelin installer (unless the rice is already installed);
2. applies the overlay, parking a copy of everything it replaces
   (`*.ricelin-bak-<timestamp>`).

Flags:

| Flag | Effect |
|---|---|
| `--skip-rice` | apply only the overlay, skip the rice installer |
| `--dry-run` | list every change, touch nothing |
| `-h` | help |

Then **log out and back in** (the keyboard layout and the new env vars only apply
to a fresh session) and check:

```sh
ricelin status     # pill running · lock running · watchdogs up
```

### Requirements

On top of the rice's own dependencies (Arch, CachyOS, EndeavourOS and friends):

| App | Why | If missing |
|---|---|---|
| `firefox` | `Super+W` | install it your way |
| `dolphin` | `Super+E` | same, or change the command in `binds.lua` |
| `ghostty`, `fish` | terminal and shell | come with the rice |
| `qt6ct` | so Qt apps (Dolphin, kdialog) use the rice palette | `sudo pacman -S qt6ct` |

Everything else (quickshell, matugen, awww, cava, hyprpicker, hypridle, rishot,
fonts, wallpapers) is installed by the rice itself.

## Keybinds

### Mine

| Key | Action |
|---|---|
| `Super+W` | Firefox |
| `Super+E` | Dolphin |
| `Alt+F1` | Maximize (keeps the gaps) |
| `Alt+F2` | Toggle tiling ↔ floating |
| `Alt+F3` | Minimize everything → desktop (press again to restore) |
| `Alt+F4` | Close the window |
| `Super+Shift+W` | Kill the process (SIGKILL) |
| `Super+Ctrl+←/→` | Move between workspaces |
| `Super+Ctrl+Shift+←/→` | Send the window to another workspace |

### The rice's

| Key | Action |
|---|---|
| `Super+Return` | Ghostty |
| `Super+Space` | App launcher |
| `Super+V` | Clipboard history |
| `Super+C` | Wallpaper picker |
| `Super+B` | Shuffle wallpaper and retheme |
| `Super+M` | Minimize the focused window |
| `Super+L` | Lock the screen |
| `Super+D` | Record the screen |
| `Super+G` | Game mode |
| `Super+Shift+C` | Pick a colour off the screen (hyprpicker) |
| `Print` | rishot (screenshot + annotate) |
| `Super+1…0` | Go to workspace N |
| `Super+Shift+1…0` | Send the window to workspace N |

Full list in [`docs/ATALHOS.md`](docs/ATALHOS.md).

## What is mine and what is Gakuseei's

| File | Origin | What changed |
|---|---|---|
| `modules/binds.lua` | **mine** | keybinds rewritten from scratch, in his style |
| `modules/monitors.lua` | **mine** | portable version (auto) + my laptop's real layout as an example |
| `modules/input.lua` | **mine** | `de` → `us` + `alt-intl` variant |
| `modules/env.lua` | **mine** | `QT_QPA_PLATFORMTHEME` from `kde` (not installed) to `qt6ct` |
| `scripts/show-desktop.sh` | **mine** | new script behind `Alt+F3` |
| `extras/qt6ct/qt6ct-palette.py` | **mine** | translates the wallpaper palette into qt6ct's format |
| `install.sh` | **mine** | installs the rice, then applies the overlay |
| `pill/`, `lock/`, `launcher/` | Gakuseei | untouched |
| `wallpaper.sh`, `wallcolors.py` | Gakuseei | untouched |
| `rishot` | Gakuseei | untouched, just installed |

## How the colour works

The most interesting part of the rice, and the part I never had to touch:

1. you change the wallpaper (`Super+C` or `Super+B`);
2. `wallpaper.sh` hands it to `awww` and calls `wallcolors.py`;
3. the script reads the image and computes the **area-dominant chromatic hue**
   (binned into hue families, so one small vivid accent cannot hijack the theme)
   and the **mean lightness**;
4. the lightness drives the whole tone: a bright wallpaper gives a light pill with
   dark text, a dark one gives a near-black pill with cream text. Surfaces and text
   flip together for contrast across the full range;
5. the dominant hue tints every tier in HSL; an achromatic wallpaper drops to a
   neutral grey ramp;
6. `matugen` builds the terminal's base16 from that same hue;
7. the result lands in `~/.cache/ricelin/`: `colors.json` (pill, lock, Hyprland
   borders, fastfetch), `ghostty-colors` (pulled in by Ghostty's `config-file`) and
   `hypr-colors.lua`.

My layer joins at step 7: `qt6ct-palette.py` reads that `colors.json` and writes a
qt6ct colour scheme, so Dolphin and the other Qt apps follow the same palette.

```sh
~/.local/bin/ricelin status        # shell health
cat ~/.cache/ricelin/colors.json   # the current palette
```

## Displays

The `monitors.lua` here is portable (one screen on `auto`). My laptop has two
screens and a fixed layout, kept in
`overlay/hypr/modules/monitors.local.lua.example` — `eDP-1` on the left,
`HDMI-A-1` on the right, workspaces 1–5 on the laptop and 6–10 on the external one.

```sh
hyprctl monitors   # your outputs and resolutions
```

To use mine, copy the example over `monitors.lua` and edit the output names.

## Keyboard

```lua
kb_layout  = "us",
kb_variant = "alt-intl",
```

The `de` the rice ships with has **Z and Y swapped** relative to US. `us` restores
the positions; `alt-intl` as the variant keeps the accented characters on `AltGr`.

> ⚠️ Hyprland takes `kb_layout` and `kb_variant` as **separate** keys. Writing
> `kb_layout = "us,alt-intl"` breaks the XKB keymap compile and leaves the
> keyboard with **no layout at all**. That was the most annoying mistake here.

## Updating

```sh
ricelin update      # updates the rice, merging my layer
git -C ~/ricelin-salgado pull
./install.sh --skip-rice   # to re-apply the overlay if anything drifted
```

## Reverting

```sh
ricelin uninstall    # removes the rice and restores the .bak files
```

Every overlay file keeps a `*.ricelin-bak-<timestamp>` copy next to it, and
`ricelin uninstall` puts the rice's own `.bak` files back.

## Known issues

Things I hit and fixed, written down in
[`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md) because they are easy to hit:

- **`kb_layout = "us,alt-intl"`** → keyboard with no layout (see above);
- **`QT_QPA_PLATFORMTHEME=kde`** → Qt apps with no theme, the KDE plugin isn't
  installed; the overlay switches to `qt6ct`;
- **`hyprctl dispatch`** → on Hyprland 0.55+ dispatchers are Lua syntax:
  `hyprctl dispatch 'hl.dsp.window.move({ workspace = "special:minimized" })'`,
  and a dispatch without `window = ...` acts on the **focused** window;
- **`awww` vs `swww`** → on CachyOS the `swww` package resolves to `awww`; where
  it doesn't exist, the installer symlinks `awww -> swww`;
- **`Property 'dnd' does not exist on Notifs`** in the Quickshell log → version
  drift, DND still works because `Notifs.qml` reads `Flags.dnd` itself.

## Layout

```
ricelin-salgado/
├── README.md / README.en.md
├── CREDITS.md            who owns what
├── LICENSE               MIT, with the original Ricelin notice embedded
├── install.sh            official rice + overlay
├── docs/
│   ├── ATALHOS.md        every keybind, annotated
│   └── TROUBLESHOOTING.md
├── overlay/
│   ├── hypr/modules/     binds, monitors, input, env
│   ├── hypr/scripts/     show-desktop.sh
│   └── extras/qt6ct/     qt6ct-palette.py
└── assets/screenshots/   (empty — see below)
```

### Screenshots

`assets/screenshots/` is deliberately empty: I did not want to publish a picture
of my screen without your say-so. To add one:

```sh
grim assets/screenshots/desktop.png        # plain capture
rishot                                    # or the annotation tool (Print)
```

then reference it at the top of the README.

## Licence

MIT — and since Ricelin is MIT, its original notice is reproduced verbatim in
[`LICENSE`](LICENSE). Full credits, including who owns every image, font and tool,
are in [`CREDITS.md`](CREDITS.md).