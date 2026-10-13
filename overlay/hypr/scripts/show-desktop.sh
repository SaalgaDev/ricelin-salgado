#!/bin/bash
#
# ALT+F3 — mostrar a area de trabalho.
#
# Toda janela em um workspace normal vai para o workspace especial "minimized"
# (o mesmo stash que o MinimizedTray da pill lista), e um segundo toque traz
# cada uma de volta para o workspace exato de onde saiu. As janelas sao
# enderecadas uma a uma com movetoworkspacesilent para a camera nunca seguir
# no meio do movimento, e os pares endereco/workspace ficam num arquivo de
# estado para o retorno ser exato.

set -u

STATE="${XDG_STATE_HOME:-$HOME/.local/state}/ricelin/desktop-stash.tsv"

# Ja estamos com tudo minimizado: restaurar.
if [ -s "$STATE" ]; then
	while IFS=$'\t' read -r addr ws; do
		[ -n "$addr" ] && [ -n "$ws" ] || continue
		hyprctl dispatch "hl.dsp.window.move({ workspace = \"$ws\", follow = false, window = \"address:$addr\" })" >/dev/null 2>&1
	done < "$STATE"
	rm -f "$STATE"
	exit 0
fi

# Minimizar tudo.
mkdir -p "$(dirname "$STATE")"
: > "$STATE"

hyprctl clients -j 2>/dev/null |
	jq -r '.[] | select(.workspace.name | startswith("special:") | not) | "\(.address)\t\(.workspace.name)"' |
	while IFS=$'\t' read -r addr ws; do
		[ -n "$addr" ] && [ -n "$ws" ] || continue
		printf '%s\t%s\n' "$addr" "$ws" >> "$STATE"
		hyprctl dispatch "hl.dsp.window.move({ workspace = \"special:minimized\", follow = false, window = \"address:$addr\" })" >/dev/null 2>&1
	done