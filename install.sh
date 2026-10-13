#!/usr/bin/env bash
#
# ricelin-salgado installer.
#
# Two steps, in order:
#   1. the official Ricelin installer (Gakuseei/Ricelin) lays down the rice itself
#   2. this overlay lands on top: the personalised keybinds, the input layout,
#      the Qt theme fix, the show-desktop script and the qt6ct palette
#
# The overlay never touches anything the rice does not own, and every file it
# replaces is copied aside first. Re-running it is safe.

set -euo pipefail

RICE_REPO="https://github.com/Gakuseei/Ricelin"
RICE_INSTALLER="https://raw.githubusercontent.com/Gakuseei/Ricelin/main/install.sh"

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
overlay="$here/overlay"
cfg="${XDG_CONFIG_HOME:-$HOME/.config}"

skip_rice=0
dry=0

usage() {
	cat <<EOF
ricelin-salgado

  --skip-rice   do not run the official Ricelin installer (overlay only)
  --dry-run     list every change, touch nothing
  -h, --help    this text

The rice itself: $RICE_REPO
EOF
}

while [ $# -gt 0 ]; do
	case "$1" in
		--skip-rice) skip_rice=1 ;;
		--dry-run) dry=1 ;;
		-h|--help) usage; exit 0 ;;
		*) echo "ricelin-salgado: unknown option '$1'" >&2; usage >&2; exit 2 ;;
	esac
	shift
done

stamp() { date +%Y%m%d-%H%M%S; }

say()  { printf '\033[38;2;224;86;59m::\033[0m %s\n' "$*"; }
warn() { printf '\033[38;2;239;106;79m::\033[0m %s\n' "$*" >&2; }
die()  { printf 'ricelin-salgado: %s\n' "$*" >&2; exit 1; }

run() {
	if [ "$dry" -eq 1 ]; then
		printf '   would: %s\n' "$*"
		return 0
	fi
	"$@"
}

# Copy src over dest, parking whatever was there under dest.ricelin-bak-<stamp>.
install_file() {
	local src="$1" dest="$2" mode="${3:-}"
	local dir; dir="$(dirname "$dest")"

	if [ ! -f "$src" ]; then
		warn "missing in overlay: $src"
		return 1
	fi

	if [ "$dry" -eq 1 ]; then
		if [ -e "$dest" ]; then
			printf '   would: backup %s -> %s\n' "$dest" "$dest.ricelin-bak-$(stamp)"
		fi
		printf '   would: install %s -> %s\n' "$src" "$dest"
		return 0
	fi

	mkdir -p "$dir"
	if [ -e "$dest" ] && ! cmp -s "$src" "$dest"; then
		cp -a "$dest" "$dest.ricelin-bak-$(stamp)"
		printf '   backup: %s\n' "$dest.ricelin-bak-*"
	fi
	cp -a "$src" "$dest"
	if [ -n "$mode" ]; then
		chmod "$mode" "$dest"
	fi
	printf '   installed: %s\n' "$dest"
}

need() {
	command -v "$1" >/dev/null 2>&1 || die "missing dependency: $1 ($2)"
}

# --------------------------------------------------------------------------
# 1. the rice itself
# --------------------------------------------------------------------------

if [ "$skip_rice" -eq 0 ]; then
	if [ -f "$cfg/hypr/.ricelin-managed" ]; then
		say "Ricelin is already installed, skipping its installer"
		say "  (update it with: ricelin update, from the pill's Settings > Updates)"
	else
		need git "install git first"
		need python3 "install python3 first"
		say "Running the official Ricelin installer"
		if [ "$dry" -eq 1 ]; then
			printf '   would: curl -fsSL %s | bash -s -- --quickstart\n' "$RICE_INSTALLER"
		else
			curl -fsSL "$RICE_INSTALLER" | bash -s -- --quickstart
		fi
	fi
else
	say "Skipping the Ricelin installer (--skip-rice)"
fi

# --------------------------------------------------------------------------
# 2. the overlay
# --------------------------------------------------------------------------

[ -d "$overlay" ] || die "overlay not found next to this script ($overlay)"

say "Applying the overlay"
install_file "$overlay/hypr/modules/binds.lua"    "$cfg/hypr/modules/binds.lua"
install_file "$overlay/hypr/modules/monitors.lua" "$cfg/hypr/modules/monitors.lua"
install_file "$overlay/hypr/modules/input.lua"    "$cfg/hypr/modules/input.lua"
install_file "$overlay/hypr/modules/env.lua"      "$cfg/hypr/modules/env.lua"
install_file "$overlay/hypr/scripts/show-desktop.sh" "$cfg/hypr/scripts/show-desktop.sh" +x

# Qt theme: the rice asks for QT_QPA_PLATFORMTHEME=kde, which needs the KDE
# platform theme plugin. env.lua above points at qt6ct instead, which is the one
# actually installed here, and this writes the colour file it reads.
if [ "$dry" -eq 1 ]; then
	printf '   would: python3 %s\n' "$overlay/extras/qt6ct/qt6ct-palette.py"
else
	need python3 "install python3 first"
	say "Writing the qt6ct palette from the live wallpaper palette"
	python3 "$overlay/extras/qt6ct/qt6ct-palette.py" || \
		warn "palette step failed; re-run after the first wallpaper change"
fi

# uwsm hands the session a TERM; leave a box that no longer has kitty on it
# pointing at a terminal that is installed.
uwsm_env="$cfg/uwsm/env"
if [ -f "$uwsm_env" ]; then
	if grep -q '^export TERM=xterm-kitty' "$uwsm_env"; then
		say "Pointing uwsm's TERM at ghostty"
		run sed -i 's/^export TERM=xterm-kitty$/export TERM=xterm-ghostty/' "$uwsm_env"
	fi
fi

if [ "$dry" -eq 1 ]; then
	say "Dry run complete, nothing changed"
	exit 0
fi

say "Done"
cat <<EOF

Next:
  1. log out and back in (or reboot). The input layout and the fresh env vars
     only apply to a new session.
  2. confirm the rice came up:  ricelin status
  3. pick a wallpaper:          Super+C  (or drop images in ~/Ricelin/wallpapers)

Keys added by this overlay:
  Super+W  firefox          Alt+F1  maximize
  Super+E  dolphin          Alt+F2  toggle tiling
  Alt+F4   close window     Alt+F3  minimize everything / restore
  Super+Ctrl+Arrow          switch workspace
  Super+Ctrl+Shift+Arrow    send the window to another workspace

If your layout is more than one screen, copy overlay/hypr/modules/monitors.local.lua.example
over overlay/hypr/modules/monitors.lua and edit the output names (hyprctl monitors).

Upstream rice and its licence: $RICE_REPO
EOF