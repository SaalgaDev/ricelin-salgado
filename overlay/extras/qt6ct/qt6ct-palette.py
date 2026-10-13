#!/usr/bin/env python3
"""
Generate a qt6ct colour scheme from the live Ricelin palette.

The Ricelin shell already publishes its wallpaper-derived palette at
~/.cache/ricelin/colors.json (written by hypr/scripts/wallcolors.py on every
wallpaper change, which happens before the install script gets here). qt6ct wants
its colours in one long positional list, so this translates the palette keys into
that order and writes the .conf.

Usage:
    qt6ct-palette.py                 # read the cache, write the .conf
    qt6ct-palette.py --config path   # write somewhere else
    qt6ct-palette.py --print         # print instead of writing
    qt6ct-palette.py --open          # also open it in qt6ct

If the cache is missing (no wallpaper picked yet), fall back to the warm
Ricelin defaults so the file is still valid, and say so on stderr.
"""
import argparse
import json
import pathlib
import subprocess
import sys

CACHE = pathlib.Path.home() / ".cache" / "ricelin" / "colors.json"
DEFAULT_DEST = pathlib.Path.home() / ".config" / "qt6ct" / "colors" / "ricelin.conf"

# The same warm palette the shell ships as its own fallback.
WARM_DEFAULT = {
    "surface": "#1c120c",
    "surface_container_low": "#241a12",
    "surface_container": "#2e231b",
    "surface_container_high": "#3a2c22",
    "surface_container_highest": "#463428",
    "outline_variant": "#594636",
    "primary": "#e0563b",
    "primary_container": "#a43c28",
    "on_primary_container": "#f0b85e",
    "outline": "#7a6453",
    "cream": "#e6d6cb",
    "bright": "#fff6f0",
    "subtle": "#c3a595",
    "dim": "#9a8071",
}

# qt6ct's positional order, documented in its own source.
ORDER = [
    ("windowText", "cream"),
    ("button", "surface_container_high"),
    ("light", "bright"),
    ("midlight", "surface_container_highest"),
    ("dark", "outline_variant"),
    ("mid", "outline"),
    ("text", "bright"),
    ("brightText", "bright"),
    ("buttonText", "cream"),
    ("base", "surface_container"),
    ("window", "surface"),
    ("shadow", "#000000"),
    ("highlight", "primary"),
    ("highlightedText", "surface"),
    ("link", "primary"),
    ("linkVisited", "primary_container"),
    ("alternateBase", "surface_container_high"),
    ("NO_IDEA", "surface_container_high"),
    ("toolTipBase", "surface_container_high"),
    ("toolTipText", "cream"),
    ("placeholderText", "dim"),
    ("accent", "primary"),
]

HEADER = """[ColorScheme]
# Gerado por ricelin-salgado/overlay/extras/qt6ct/qt6ct-palette.py
# Fonte: a paleta do wallpaper que o Ricelin publica em
#        ~/.cache/ricelin/colors.json
# Ordem posicional do qt6ct: windowText, button, light, midlight, dark, mid,
# text, brightText, buttonText, base, window, shadow, highlight,
# highlightedText, link, linkVisited, alternateBase, NO_IDEA, toolTipBase,
# toolTipText, placeholderText, accent
"""


def load():
    if CACHE.is_file():
        try:
            data = json.loads(CACHE.read_text())
            # A key starting with "#" is a literal colour, not a palette key.
            wanted = [k for _, k in ORDER if not k.startswith("#")]
            missing = [k for k in wanted if k not in data]
            if not missing:
                return data, CACHE
            print(f"qt6ct-palette: cache incomplete, missing {missing}", file=sys.stderr)
        except (OSError, ValueError) as exc:
            print(f"qt6ct-palette: cache unreadable ({exc})", file=sys.stderr)
    print("qt6ct-palette: no palette cache yet, using the warm fallback. "
          "Re-run after the first wallpaper change.", file=sys.stderr)
    return WARM_DEFAULT, None


def render(palette):
    values = []
    for _name, key in ORDER:
        # A key starting with "#" is a literal colour; the rest is a palette key.
        values.append(key if key.startswith("#") else palette.get(key, "#888888"))
    line = ", ".join(values)
    return HEADER + f"active_colors={line}\ndisabled_colors={line}\ninactive_colors={line}\n"


def point_qt6ct(dest):
    """Point qt6ct at the generated file, creating its config if absent."""
    conf = pathlib.Path.home() / ".config" / "qt6ct" / "qt6ct.conf"
    conf.parent.mkdir(parents=True, exist_ok=True)
    line = f"color_scheme_path={dest}"
    if not conf.is_file():
        conf.write_text("[Appearance]\n" + line + "\ncustom_palette=true\n")
        return f"qt6ct.conf criado -> {line}"
    text = conf.read_text()
    if line in text:
        return "qt6ct.conf ja aponta para a paleta"
    lines, replaced = [], False
    for entry in text.splitlines():
        if entry.startswith("color_scheme_path="):
            lines.append(line)
            replaced = True
        else:
            lines.append(entry)
    if not replaced:
        lines.append(line)
    conf.write_text("\n".join(lines) + "\n")
    return f"qt6ct.conf atualizado -> {line}"


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--config", default=str(DEFAULT_DEST))
    ap.add_argument("--print", dest="show", action="store_true")
    ap.add_argument("--open", dest="open_ui", action="store_true")
    args = ap.parse_args()

    palette, source = load()
    body = render(palette)
    if args.show:
        print(body)
        return 0

    dest = pathlib.Path(args.config)
    dest.parent.mkdir(parents=True, exist_ok=True)
    dest.write_text(body)
    print(f"qt6ct-palette: escrito {dest} (fonte: {source or 'fallback quente'})")
    print("qt6ct-palette: " + point_qt6ct(dest))
    if args.open_ui:
        subprocess.run(["qt6ct"], check=False)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())