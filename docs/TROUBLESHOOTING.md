# Troubleshooting

Tudo aqui aconteceu de verdade na instalação deste overlay. Os quatro primeiros
erros custaram tempo e valem conferir antes de caçar a causa em outro lugar.

---

## 1. O teclado parou de funcionar depois do reload

**Sintoma:** teclas mortas, `hyprctl devices` mostrando `active_layout: null`, e
no log:

```
xkbcommon: ERROR: [XKB-661] Couldn't process include statement for 'alt-intl'
xkbcommon: ERROR: [XKB-822] Failed to compile keymap
```

**Causa:** escrever o layout e a variante na mesma chave.

```lua
-- ERRADO: quebra a compilação do keymap
kb_layout = "us,alt-intl",

-- CERTO
kb_layout  = "us",
kb_variant = "alt-intl",
```

O Hyprland tem `kb_layout` e `kb_variant` como chaves separadas. A string
`também separada` nunca é interpretada como layout+variante: ele tenta abrir um
arquivo de layout chamado `alt-intl`, não acha, e o keymap inteiro morre.

**Confirme que compilou:**

```sh
xkbcli compile-keymap --layout us --variant alt-intl >/dev/null && echo ok
hyprctl getoption input:kb_layout
hyprctl getoption input:kb_variant
```

> Nota: `active_layout` pode mostrar `null` mesmo com tudo funcionando, dependendo
> do dispositivo. O teste confiável é o da keysym com o `xkbcli` acima, ou
> simplesmente digitar.

## 2. Z e Y saem trocados

Não é o teclado: é o layout. `de` (alemão) tem **Z na fileira de cima e Y na de
baixo**, o oposto do US. O rice vem com `de`.

```lua
kb_layout  = "us",       -- posições do US
kb_variant = "alt-intl", -- acentos no AltGr
```

Se preferir ABNT2 completo (ç, ã, õ diretos), use `kb_layout = "br"` e deixe o
`kb_variant` vazio.

## 3. Apps Qt (Dolphin, kdialog) sem tema

O rice exporta `QT_QPA_PLATFORMTHEME=kde`, mas o plugin do KDE não é dependência
do rice e não vem instalado. O que existe aí é o `qt6ct`.

```
/usr/lib/qt6/plugins/platformthemes/  ->  libqgtk3.so  libqt6ct.so  libqxdgdesktopportal.so
```

Este overlay troca `env.lua` para `qt6ct` e gera o esquema de cores a partir da
paleta do wallpaper:

```sh
python3 overlay/extras/qt6ct/qt6ct-palette.py
python3 overlay/extras/qt6ct/qt6ct-palette.py --print   # só ver
```

Se a paleta ainda não existir (nenhum papel de parede escolhido), o script cai
num fallback quente e avisa no stderr — rode de novo depois de trocar o papel de
parede.

## 4. `hyprctl dispatch` reclamando de sintaxe

No Hyprland 0.55+ os dispatchers são **sintaxe Lua**, não o formato antigo com
dois argumentos:

```sh
# ERRADO
hyprctl dispatch movetoworkspacesilent "special:minimized" "address:0x..."
# erro: [string "return hl.dispatch(movetoworkspacesilent spec..."]:1: ')' expected near 'special'

# CERTO
hyprctl dispatch 'hl.dsp.window.move({ workspace = "special:minimized", follow = false, window = "address:0x..." })'
```

Dois detalhes que custaram uma janela aqui:

- **Sempre passe `window = "address:..."`.** Sem isso o dispatch age na janela em
  foco. Testar "só para ver" com um endereço falso move a janela que estava em foco.
- O `follow = false` impede que a câmera siga a janela no meio de um laço.

## 5. O papel de parede não aparece

O rice chama o binário `awww`. O pacote se chama `swww`:

| Distro | `swww` resolve para | Tem `awww`? |
|---|---|---|
| CachyOS | `awww` (que declara `Provides: swww`) | sim |
| Arch puro | `swww` | não |

Onde não tem `awww`, o instalador do rice cria o symlink em `~/.local/bin`:

```sh
command -v awww || ls -l ~/.local/bin/awww
```

Se o wallpaper não colar, confira se `~/.local/bin` está no `PATH` e veja o log:

```sh
tail -20 ~/.local/state/ricelin/wallcolors.log
```

## 6. `Property 'dnd' does not exist on Notifs`

Aviso do Quickshell 0.3.x ao carregar a pill. Drift de versão: o `Binding` em
`pill/shell.qml` tenta escrever `dnd` no singletone de notificações, que não tem
essa propriedade. **O DND funciona** — o próprio `Notifs.qml` consulta
`Flags.dnd` antes de exibir qualquer notificação. Não mexi nisso para não
diverge do upstream.

## 7. `awww-daemon` reaparecendo, ou a pill subindo duas vezes

Ambos sãoynos scripts `watchdog.sh`, que é proposital: o Quickshell não se
protege de uma segunda instância do mesmo config, então o watchdog sobe uma, espera
ela responder no IPC e só então entra no laço de ressurreição (com `flock`, para
não duplicar).

```sh
ricelin status          # mostra "running · watchdog up"
pgrep -a qs
```

## 8. Monitores na ordem errada, ou apenas um recognized

O instalador do rice neutraliza `monitors.lua` para um monitor `auto` genérico.
Para um layout fixo:

```sh
hyprctl monitors                  # nome, resolução e posição de cada saída
cp overlay/hypr/modules/monitors.local.lua.example ~/.config/hypr/modules/monitors.lua
```

O `monitor` aceita `output`, `mode`, `position` e `scale`. Ajustando o `position`
é que a disposição sai como você quer.

## 9. Quickshell não sobe: `Wallpaper.qml` e `QtMultimedia`

`quickshell` não depende de `qt6-multimedia`, então numa máquina sem ele o
`shell.qml` da pill não carrega. É dependência do rice, mas se você instalou por
outro caminho:

```sh
sudo pacman -S qt6-multimedia-ffmpeg      # Arch / CachyOS
```

Teste rápido, sem esperar o login:

```sh
qs -c pill   # procura por "Configuration Loaded" no log
```

## 10. `ricelin update` versus o overlay

Os arquivos do overlay (`binds`, `monitors`, `input`, `env`, `spaces`,
`decorations`, `animations`, `autostart`, `hypridle.conf`, `config.fish`) estão na
lista `PRESERVED` do instalador do rice, e o atualizador faz merge de três vias
nesses arquivos. Ele nunca sobrescreve uma edição sua.

Se um arquivo seu for sobrescrito de qualquer forma, o overlay guardou uma cópia
com sufixo antes de escrever:

```sh
ls ~/.config/hypr/modules/*.ricelin-bak-* 2>/dev/null
```

E o `install.sh --skip-rice` reaplica tudo sem mexer no resto.

## 11. Restaurando tudo

```sh
ricelin uninstall      # remove o rice e devolve os .bak originais
```

E se quiser só desfazer a minha camada, cada arquivo tem o backup com data ao lado,
ou basta rodar o `install.sh` do rice puro por cima.