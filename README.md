<div align="center">

# ricelin-salgado

**Minha personalização do [Ricelin](https://github.com/Gakuseei/Ricelin)** — CachyOS, Hyprland em
Lua, shell em Quickshell (pill), terminal Ghostty, paleta puxada do papel de parede.

[**Créditos e licença**](CREDITS.md) · [Em inglês](README.en.md)

</div>

---

## ⚠️ Antes de tudo: os créditos

Este repositório **não é um rice do zero**. Ele é uma camada pessoal por cima do
**[Ricelin](https://github.com/Gakuseei/Ricelin)**, de **Gakuseei**, MIT, © 2026.

Tudo que você vê na tela — o compositor em Lua, a pill que se transforma em
calendário/mixer/seletor de papel de parede, a tela de bloqueio, o `rishot`, o
motor de paleta, os scripts, o instalador — é trabalho do Gakuseei. O que está
neste repositório são os meus ajustes: os atalhos, o layout de teclado, o ajuste
do tema Qt e o script de `Alt+F3`.

Também do Gakuseei, e igualmente intocado aqui: o
[`rishot`](https://github.com/Gakuseei/rishot) (captura + anotação, ligado ao `Print`).

Se você quer o rice completo, use o repositório original:

```sh
curl -fsSL https://raw.githubusercontent.com/Gakuseei/Ricelin/main/install.sh | bash -s -- --quickstart
```

Instalado por aqui, referenciado na revisão `2109754` (26/09/2026).

---

## O que é

Um rice em duas camadas:

```
┌─ ricelin-salgado (este repo) ────────────────────────────┐
│  overlay/hypr/modules/binds.lua      atalhos             │
│  overlay/hypr/modules/monitors.lua   telas               │
│  overlay/hypr/modules/input.lua      teclado             │
│  overlay/hypr/modules/env.lua        tema Qt             │
│  overlay/hypr/scripts/show-desktop.sh  Alt+F3            │
│  overlay/extras/qt6ct/               paleta p/ Qt apps   │
└───────────────────────┬─────────────────────────────────┘
                        │  install.sh aplica por cima
                        ▼
┌─ Ricelin (Gakuseei) ─────────────────────────────────────┐
│  hyprland.lua + modules/*.lua      compositor em Lua     │
│  quickshell/pill + lock + launcher shell em Quickshell   │
│  ghostty, fish, fastfetch, rishot                        │
│  wallpaper.sh, wallcolors.py, matugen                   │
└──────────────────────────────────────────────────────────┘
```

Separar assim tem uma vantagem prática: o `ricelin update` continua funcionando
sem desfazer nada meu, porque os arquivos do overlay estão todos na lista
`PRESERVED` do instalador do rice — o atualizador faz *merge* deles em vez de
sobrescrever.

### A stack, em detalhe

| Camada | Ferramenta |
|---|---|
| OS | CachyOS (rolling, base Arch) |
| Compositor | Hyprland, configurado em **Lua** (`~/.config/hypr/hyprland.lua` só faz `require` dos módulos) |
| Shell UI | Quickshell, escrito à mão pelo autor: **pill** (barra que morfa em mixer/calendário/clipboard/wifi/bt/tray/OSD/settings), **lock**, **launcher** |
| Login | greetd + `noctalia-greeter` (paleta e wallpaper sincronizados por `greeter-sync`, nesta máquina) |
| Terminal / shell | Ghostty (transparência, tema gerado) · fish (saudação `torii-greeting.sh`, zoxide) |
| Cores | `wallcolors.py` + matugen → `~/.cache/ricelin/` |
| Wallpaper | `awww` (pics e vídeos) |
| Áudio / rede / BT | pipewire, wireplumber, bluez, NetworkManager |
| Extras do dia a dia | btop, fastfetch, cava, dolphin, firefox, spotify-launcher |

## Instalação

```sh
git clone https://github.com/SaalgaDev/ricelin-salgado.git
cd ricelin-salgado
./install.sh
```

Ou em uma linha:

```sh
git clone https://github.com/SaalgaDev/ricelin-salgado.git && \
  ricelin-salgado/install.sh
```

O `install.sh` faz duas coisas, nessa ordem:

1. chama o instalador oficial do Ricelin (a não ser que o rice já esteja instalado);
2. aplica o overlay, guardando uma cópia de tudo que substituir (`*.ricelin-bak-<data>`).

Opções:

| Flag | O que faz |
|---|---|
| `--skip-rice` | só aplica o overlay, não roda o instalador do rice |
| `--dry-run` | lista tudo que faria, não muda nada |
| `-h` | ajuda |

Depois é só **deslogar e logar de novo** (o layout de teclado e as variáveis de
ambiente só valem numa sessão nova) e conferir:

```sh
ricelin status     # pill running · lock running · watchdogs up
```

### Requisitos

Além das dependências do próprio rice (Arch, CachyOS, EndeavourOS e afins):

| App | Por quê | Se faltar |
|---|---|---|
| `firefox` | `Super+W` | instale pelo seu gerenciador |
| `dolphin` | `Super+E` | idem, ou troque o comando em `binds.lua` |
| `ghostty`, `fish` | terminal e shell | vêm com o rice |
| `qt6ct` | apps Qt (Dolphin, kdialog) usarem a paleta do rice | `sudo pacman -S qt6ct` |
| `gnome-system-monitor` | `Ctrl+Shift+Esc` (só nesta máquina) | ou remova o atalho |

O resto (quickshell, matugen, awww, cava, hyprpicker, hypridle, hyprpolkitagent,
rishot, fontes, papéis de parede) é instalado pelo próprio rice. Áudio, BT e rede
vêm do sistema: `pipewire`, `wireplumber`, `bluez-utils`, `networkmanager`.

## Atalhos

### Os meus

| Tecla | Ação |
|---|---|
| `Super+W` | Firefox |
| `Super+E` | Dolphin |
| `Super+R` | Spotify 🖥 *só nesta máquina* |
| `Alt+F1` | Maximiza a janela (mantém as bordas) |
| `Alt+F2` | Alterna tiling ↔ flutuante |
| `Alt+F3` | Minimiza tudo → área de trabalho (segundo toque restaura tudo) |
| `Alt+F4` | Fecha a janela |
| `Super+Shift+W` | Mata o processo (SIGKILL) |
| `Ctrl+Shift+Esc` | Gerenciador de tarefas 🖥 *só nesta máquina* |
| `Super+Ctrl+←/→` | Viaja entre as áreas de trabalho |
| `Super+Ctrl+Shift+←/→` | Move a janela para outra área de trabalho |

### Os do rice

| Tecla | Ação |
|---|---|
| `Super+Return` | Ghostty |
| `Super+Space` | Lançador de apps |
| `Super+V` | Histórico da área de transferência |
| `Super+C` | Seletor de papel de parede |
| `Super+B` | Troca o papel de parede e re-tematiza |
| `Super+M` | Minimiza a janela da frente |
| `Super+L` | Trava a tela |
| `Super+D` | Grava a tela |
| `Super+G` | Modo jogo |
| `Super+Shift+C` | Pega uma cor da tela (hyprpicker) |
| `Print` | rishot (captura + anota) |
| `Shift+Print` | rishot no monitor inteiro |
| `Super+1…0` | Vai para a área N |
| `Super+Shift+1…0` | Manda a janela para a área N |
| `Super+←/→` | Viaja entre as áreas |
| `Super+S` / `Super+P` | Workspaces especiais (stash / privado) |
| `Super+Shift+S` | 🖥 **nesta máquina** virou rishot (no repo é o stash) |
| `Super+A` | Workspace do Discord (gerado pelo `spaces.lua`) |
| `XF86Audio*` / `XF86MonBrightness*` | Volume, mídia e brilho |

🖥 = mudança que existe na minha máquina mas ainda não foi levada para o `overlay/` do repo
(veja [Drift da máquina](#drift-da-máquina-vs-repo)). Lista completa e comentada em
[`docs/ATALHOS.md`](docs/ATALHOS.md).

## O que é meu e o que é do Gakuseei

| Arquivo | Origem | O que mudou |
|---|---|---|
| `modules/binds.lua` | **meu** | atalhos reescritos do zero, na convenção dele |
| `modules/monitors.lua` | **meu** | versão portátil (auto) + exemplo do meu notebook |
| `modules/input.lua` | **meu** | `de` → `us` + variante `alt-intl` |
| `modules/env.lua` | **meu** | `QT_QPA_PLATFORMTHEME` de `kde` (inexistente) para `qt6ct` |
| `scripts/show-desktop.sh` | **meu** | script novo do `Alt+F3` |
| `extras/qt6ct/qt6ct-palette.py` | **meu** | traduz a paleta do wallpaper para o formato do qt6ct |
| `install.sh` | **meu** | instala o rice e aplica o overlay |
| `pill/`, `lock/`, `launcher/` | Gakuseei | intocado |
| `wallpaper.sh`, `wallcolors.py` | Gakuseei | intocado |
| `rishot` | Gakuseei | intocado, só instalado |

## Como a cor funciona

O ponto mais interessante do rice, e a parte que eu não precisei mexer:

1. você troca o papel de parede (`Super+C` ou `Super+B`);
2. `wallpaper.sh` manda pro `awww` e chama `wallcolors.py`;
3. o script lê a imagem, calcula o **hue dominante por histograma** (agrupado em
   famílias de matiz, para um acento pequeno e vivo não sequestrar o tema) e a
   **luminosidade média**;
4. a luminosidade decide o tom de tudo: papel de parede claro → pill clara com
   texto escuro; papel escuro → pill quase preta com texto creme. As superfícies
   e o texto invertem juntos;
5. o matiz pinta os níveis de superfície em HSL; wallpaper acromático cai num
   cinza neutro;
6. o `matugen` monta o base16 do terminal a partir do mesmo matiz;
7. o resultado vai para `~/.cache/ricelin/`:
   `colors.json` (a pill, o lock, as bordas do Hyprland, o fastfetch),
   `ghostty-colors` (incluído pelo `config-file` do Ghostty) e
   `hypr-colors.lua`.

O caminho completo dos arquivos:

```
wallpaper (awww)
  └─ wallcolors.py  →  ~/.cache/ricelin/colors.json        (pill, lock, fastfetch)
                    →  ~/.cache/ricelin/hypr-colors.lua    (bordas das janelas)
                    →  ~/.cache/ricelin/ghostty-colors     (tema do terminal)
       └─ qt6ct-palette.py (minha camada)  →  ~/.config/qt6ct/colors/
```

Minha camada entra no passo 7: o `qt6ct-palette.py` lê esse `colors.json` e
escreve um esquema de cores para o qt6ct, para o Dolphin e os outros apps Qt
seguirem a mesma paleta.

```sh
~/.local/bin/ricelin status        # saúde do shell
cat ~/.cache/ricelin/colors.json   # a paleta atual
```

## Extras nesta máquina (fora do repo)

Coisas que uso no dia a dia e que ainda não são parte do `overlay/`. Estão
documentadas aqui para eu não esquecer que existem:

- **`descanso`** (`~/.local/bin/descanso`) — painel de descanso: grade 2x2 de
  janelas flutuantes com `tty-clock`, `cbonsai`, `cmatrix` e `cava` (config
  especial em `~/.config/cava/descanso.conf`, barras horizontais centralizadas).
  Variáveis: `DESCANSO_TERM`, `DESCANSO_TILE` (ex.: `1x4`), `DESCANSO_GAP`,
  `DESCANSO_FECHA`.
- **`greeter-sync`** (`~/.local/bin/greeter-sync`) — empurra wallpaper + paleta
  para o `noctalia-greeter` (greetd) via `pkexec`; o `greeter.toml` da home deixa
  o login minimalista (relógio grande, sem botões de energia, `scheme = Synced`).
  As mudanças aparecem no próximo login.
- **Saudação da fish** — `~/.config/fish/torii-greeting.sh` mostra relógio, uptime,
  CPU e o wallpaper atual, na paleta vermelhão da casa.
- **Scripts legados `waybar-*`** em `~/.local/bin` — da era Waybar; a barra hoje é
  a pill. Dá para reaproveitar os popups de BT/rede por outro launcher.
- **Waybar e kitty** continuam instalados no sistema mas não são usados; a lista
  de créditos deles está no [`CREDITS.md`](CREDITS.md).

### Drift da máquina vs repo

O `binds.lua` e o `env.lua` que estão rodando em `~/.config/hypr/` já saíram do
que o `overlay/` publica:

| Arquivo | No repo (`overlay/`) | Na máquina |
|---|---|---|
| `binds.lua` | `Super+Shift+S` = stash | `Super+Shift+S` = rishot; `Super+R` = spotify; `Ctrl+Shift+Esc` = gerenciador de tarefas |
| `monitors.lua` | portátil, uma tela em `auto` | fixo: `eDP-1` + `HDMI-A-1`, áreas 1–5 / 6–10 |
| `env.lua` | só o tema Qt | mais o `PATH` com `~/.local/bin` |

Para fechar o ciclo: copiar essas mudanças de volta para o `overlay/` (e atualizar
`docs/ATALHOS.md`, que ainda registra `Super+Shift+S` como stash), ou reverter a
máquina com `./install.sh --skip-rice`.

## Telas

O `monitors.lua` daqui é portátil (uma tela em `auto`). O meu notebook tem dois
monitores e um layout fixo, que está em
`overlay/hypr/modules/monitors.local.lua.example` — `eDP-1` à esquerda,
`HDMI-A-1` à direita, e os workspaces 1–5 no notebook, 6–10 no monitor.

```sh
hyprctl monitors   # nomes e resolução das suas telas
```

Para usar o seu, copie o exemplo por cima do `monitors.lua` e edite os nomes.

## Teclado

```lua
kb_layout  = "us",
kb_variant = "alt-intl",
```

O `de` que vem no rice tem **Z e Y trocados** em relação ao US. `us` volta as
posições; `alt-intl` como variante mantém os acentos no `AltGr`.

> ⚠️ O Hyprland usa `kb_layout` e `kb_variant` **separados**. Escrever
> `kb_layout = "us,alt-intl"` quebra a compilação do keymap do XKB e deixa o
> teclado **sem layout nenhum**. É o erro mais chato que eu cometi aqui.

## Saúde e operação do dia a dia

```sh
ricelin status              # pill, lock e watchdogs
ricelin restart pill        # reinicia só a barra
ricelin log lock            # segue o log da tela de bloqueio
ricelin update              # atualiza o rice (merge do que é meu)
hyprctl binds               # atalhos valendo agora
hyprctl monitors            # telas
```

As superfícies (pill e lock) ficam vivas por causa do `watchdog.sh`, que
ressuscita o `qs -c <nome>` a cada 5s se morrer. Por isso `ricelin stop` derruba o
watchdog junto — senão a superfície volta sozinha.

## Atualizando

```sh
ricelin update      # atualiza o rice, com merge do que é meu
git -C ~/ricelin-salgado pull
./install.sh --skip-rice   # se algo do overlay precisar ser reaplicado
```

## Desfazendo

```sh
ricelin uninstall    # remove o rice e restaura os .bak
```

Os arquivos do overlay deixam cópias `*.ricelin-bak-<data>` ao lado de cada um,
e o `ricelin uninstall` devolve os `.bak` originais do rice.

## Problemas conhecidos

Coisas que eu encontrei e resolvi, documentadas em
[`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md) porque são fáceis de bater:

- **`kb_layout = "us,alt-intl"`** → teclado sem layout (veja acima);
- **`QT_QPA_PLATFORMTHEME=kde`** → apps Qt sem tema, o plugin do KDE não está
  instalado; o overlay troca por `qt6ct`;
- **`hyprctl dispatch`** → no Hyprland 0.55+ os dispatchers são sintaxe Lua:
  `hyprctl dispatch 'hl.dsp.window.move({ workspace = "special:minimized" })'`;
  e um dispatch sem `window = ...` age na **janela em foco**;
- **`awww` vs `swww`** → no CachyOS o pacote `swww` resolve para o `awww`; em
  distros onde não existe, o instalador cria o symlink `awww -> swww`;
- **aviso `Property 'dnd' does not exist on Notifs`** no log do Quickshell →
  drift de versão, o DND continua funcionando porque o próprio `Notifs.qml` lê
  `Flags.dnd`;
- **`~/.local/bin` fora do PATH do compositor** → dispatchers e binds do Hyprland
  não acham `rishot` e scripts de usuário; o `env.lua` da máquina mete o caminho
  absoluto no `PATH` e os binds usam caminho absoluto por segurança.

## Estrutura

```
ricelin-salgado/
├── README.md / README.en.md
├── CREDITS.md            de quem é cada coisa
├── LICENSE               MIT, com o aviso original do Ricelin embutido
├── install.sh            rice oficial + overlay
├── docs/
│   ├── ATALHOS.md        todos os atalhos, comentados
│   └── TROUBLESHOOTING.md
├── overlay/
│   ├── hypr/modules/     binds, monitors, input, env
│   ├── hypr/scripts/     show-desktop.sh
│   └── extras/qt6ct/     qt6ct-palette.py
└── assets/screenshots/   (vazio — veja abaixo)
```

Depois de instalado, o que muda na máquina fica todo em `~/.config/hypr/`
(módulos Lua + `scripts/`) e nos caches `~/.cache/ricelin/` e
`~/.local/state/ricelin/`.

### Prints

A pasta `assets/screenshots/` está vazia de propósito: eu não queria publicar
uma imagem da minha tela sem você ver antes. Para adicionar:

```sh
grim assets/screenshots/desktop.png        # captura crua
rishot                                    # ou a ferramenta de anotação (Print)
```

e depois apontar no topo do README.

## Licença

MIT — e, como o Ricelin é MIT, o aviso original dele vem junto no
[`LICENSE`](LICENSE). Os créditos completos, incluindo de quem é cada imagem,
fonte e ferramenta, estão no [`CREDITS.md`](CREDITS.md).
