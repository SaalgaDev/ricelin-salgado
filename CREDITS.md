# Créditos

## O rice

**Ricelin** — <https://github.com/Gakuseei/Ricelin>
Copyright (c) 2026 **Gakuseei** · MIT

Todo o desktop que este repositório customiza é o Ricelin: o compositor em
Lua, a shell em Quickshell, a tela de bloqueio, o `rishot`, o gerador de paleta
do papel de parede, os scripts, o instalador. Este repositório é só a camada
personal por cima — atalhos, layout de teclado, ajuste do tema Qt e o script
`Alt+F3`.

O trabalho original, a documentação, os prints e a licença são do Gakuseei.
Se você quer o rice completo, use o repositório dele:

```sh
curl -fsSL https://raw.githubusercontent.com/Gakuseei/Ricelin/main/install.sh | bash -s -- --quickstart
```

O `install.sh` deste repositório chama exatamente esse comando, e depois aplica
o overlay. Quem instalou pelo caminho do Gakuseei não perde nada: os arquivos do
overlay estão todos na lista `PRESERVED` do instalador do rice, ou seja,
`ricelin update` faz merge deles e nunca sobrescreve.

**Referência usada neste repositório:** commit `2109754` do Ricelin
(26 de setembro de 2026).

## rishot — ferramenta de captura

<https://github.com/Gakuseei/rishot>
Copyright (c) 2026 **Gakuseei** · MIT

Screenshot com anotação, instalado pelo instalador do rice e ligado no `Print`.

## Arte de terceiros (NÃO incluída aqui)

O rice não embarca os papéis de parede e o mesmo vale para este repositório: as
imagens são arte de terceiros, hospedadas no [wallhaven.cc](https://wallhaven.cc).
Cada arquivo na sua máquina se chama `wh-<id>`, que é o id do wallhaven, então dá
para achar a origem de qualquer imagem que você estiver usando:

| Arquivo | Wallhaven | Autoria | Resolução |
|---|---|---|---|
| `wh-gp7mq3.jpg` (o que está em uso) | [`gp7mq3`](https://whvn.cc/gp7mq3) | [original no Pixiv](https://www.pixiv.net/en/artworks/84166210) | 3840×2160 |
| `wh-z8zkmw.jpg` | [`z8zkmw`](https://whvn.cc/z8zkmw) | [original no ArtStation](https://www.artstation.com/artwork/NR65d) | 2560×1440 |
| `wh-d8pq7j.png` | [`d8pq7j`](https://whvn.cc/d8pq7j) | enviado ao wallhaven por **Zarki** | 3840×2160 |

São as três imagens *starter* que o instalador do Ricelin semeia em
`~/Ricelin/wallpapers`. Baixe as suas, de graça, em <https://wallhaven.cc>.

O resto da lista de imagens que o autor usa está em
[WALLPAPERS.md no repositório do Ricelin](https://github.com/Gakuseei/Ricelin/blob/main/WALLPAPERS.md).

## Tela de bloqueio e tema de login

Créditos originais do próprio rice, em
[`configs/sddm/themes/torii/CREDITS.md`](https://github.com/Gakuseei/Ricelin/blob/main/configs/sddm/themes/torii/CREDITS.md):

- **Vídeo de fundo:** "Winter Japanese Torii Gate", via
  [MoeWalls](https://moewalls.com/landscape/winter-japanese-torii-gate-live-wallpaper/)
- **Composição do tema:** inspirada na coleção de temas SDDM
  [qylock](https://github.com/Darkkal44/qylock), sem código copiado
- **Fonte:** Inter

## Fontes

| Fonte | Papel | Licença |
|---|---|---|
| [JetBrains Mono Nerd Font](https://www.nerdfonts.com/font-downloads) | ícones da pill e do terminal | SIL OFL 1.1 |
| [Inter](https://rsms.me/inter/) | tipografia da interface | SIL OFL 1.1 |
| Noto, Noto CJK, Noto Color Emoji | glifos base, CJK, emoji | SIL OFL 1.1 |

## Cursor

[Bibata Modern Ice](https://github.com/ful1e5/Bibata-Modern-Ice) · MIT

## Ícones

Papirus Icon Theme · LGPL-3.0

## Ferramentas

[Quickshell](https://quickshell.outfoxxed.me/) (LGPL-3.0) ·
[Hyprland](https://github.com/hyprwm/Hyprland) (BSD-3) ·
[Ghostty](https://ghostty.org/) (MIT) ·
[fish](https://fishshell.com/) (GPL-2.0) ·
[matugen](https://github.com/InioX/matugen) (GPL-3.0) ·
[awww](https://github.com/LGFae/swww) (MIT) ·
[cava](https://github.com/karlstav/cava) (MIT) ·
[hyprpicker](https://github.com/hyprwm/hyprpicker) (BSD-3) ·
[hypridle](https://github.com/hyprwm/hypridle) (BSD-3) ·
[hyprpolkitagent](https://github.com/hyprwm/hyprpolkit-agent) (BSD-3) ·
[hyprsunset](https://github.com/hyprwm/hyprsunset) (BSD-3) ·
[cliphist](https://github.com/slok/cliphist) (MIT) ·
[zoxide](https://github.com/ajeetdsouza/zoxide) (MIT) ·
[dotool](https://git.sr.ht/~geb/dotool) (MIT) ·
[fish-greeting](https://github.com/Gakuseei/Ricelin) (`torii-greeting.sh`) ·
[ImageMagick](https://imagemagick.org/) (Apache-2.0) ·
[jq](https://jqlang.github.io/jq/) (MIT) ·
[kitty](https://sw.kovidgoyal.net/kitty/) e
[Waybar](https://github.com/Alexays/Waybar) — usados no setup anterior a este
overlay, removidos depois da migração.

## rice anterior (não é mais usado)

Este overlay nasceu da troca de um setup **Waybar + Noctalia + kitty/alacritty**
por Hyprland + Quickshell + Ghostty. O repositório não carrega nenhuma config do
setup antigo.