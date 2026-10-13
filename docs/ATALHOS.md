# Atalhos

Referência completa do que está em `overlay/hypr/modules/binds.lua`, mais o que
vem do resto do rice.

Legenda: 🟢 meu · ⚪ do [Ricelin](https://github.com/Gakuseei/Ricelin)

## Aplicativos

| Tecla | Ação | |
|---|---|---|
| `Super+Return` | Ghostty | ⚪ |
| `Super+W` | Firefox | 🟢 |
| `Super+E` | Dolphin (explorador de arquivos) | 🟢 |
| `Super+Space` | Lançador de apps | ⚪ |
| `Super+V` | Histórico da área de transferência | ⚪ |
| `Super+G` | Modo jogo | ⚪ |
| `Print` | rishot — captura e anota | ⚪ |
| `Shift+Print` | rishot em tela cheia | ⚪ |

## Janela

| Tecla | Ação | |
|---|---|---|
| `Alt+F1` | Maximiza (modo `maximized`, mantém as bordas) | 🟢 |
| `Alt+F2` | Alterna tiling ↔ flutuante | 🟢 |
| `Alt+F3` | Minimiza tudo → área de trabalho | 🟢 |
| `Alt+F4` | Fecha a janela | 🟢 |
| `Super+F` | Fullscreen | ⚪ |
| `Super+T` | Alterna tiling ↔ flutuante (atalho antigo, mantido) | ⚪ |
| `Super+M` | Minimiza a janela da frente | ⚪ |
| `Super+Shift+M` | Abre a pilha de minimizados | ⚪ |
| `Super+Shift+W` | Mata o processo com SIGKILL | 🟢 |
| `Ctrl+Shift+W` | Fecha a janela (atalho antigo, mantido) | ⚪ |
| `Super+mouse:272` | Arrasta a janela | ⚪ |
| `Super+mouse:273` | Redimensiona a janela | ⚪ |

> `Alt+F1`–`Alt+F4` podem ser interceptados pelo próprio aplicativo antes de
> chegar no compositor. Nesses casos `Ctrl+Shift+W` fecha do mesmo jeito.

## Áreas de trabalho

| Tecla | Ação | |
|---|---|---|
| `Super+←/→` | Viaja entre as áreas | ⚪ |
| `Super+Ctrl+←/→` | Viaja entre as áreas | 🟢 |
| `Super+Ctrl+Shift+←/→` | Move a janela para outra área | 🟢 |
| `Super+1…0` | Vai para a área N | ⚪ |
| `Super+Shift+1…0` | Manda a janela para a área N | ⚪ |
| `Super+←/→` no mouse | Viaja entre as áreas | ⚪ |

Nas minhas duas telas, as áreas 1–5 ficam no notebook e 6–10 no monitor externo
(veja `monitors.lua`).

## Workspaces especiais

| Tecla | Ação | |
|---|---|---|
| `Super+P` | Workspace privado | ⚪ |
| `Super+Shift+P` | Envia/recupera a janela do workspace privado | ⚪ |
| `Super+S` | Workspace stash | ⚪ |
| `Super+Shift+S` | Envia/recupera a janela do stash | ⚪ |
| `Super+A` | Workspace do Discord (definido em `modules/spaces.lua`) | ⚪ |

O `spaces.lua` é editado pela própria Settings da pill, então os workspaces
especiais que você criar aparecem aí e ganham tecla sozinhos.

## Sistema

| Tecla | Ação | |
|---|---|---|
| `Super+L` | Trava a tela | ⚪ |
| `Super+B` | Troca o papel de parede e re-tematiza | ⚪ |
| `Super+C` | Seletor de papel de parede | ⚪ |
| `Super+Shift+C` | hyprpicker — pega uma cor da tela | ⚪ |
| `Super+D` | Grava a tela | ⚪ |
| `XF86AudioRaise/Lower/Mute` | Volume | ⚪ |
| `XF86AudioPlay/Next/Prev` | Mídia (MPRIS) | ⚪ |
| `XF86MonBrightnessUp/Down` | Brilho | ⚪ |

## Onde editar

- **Meus atalhos:** `~/.config/hypr/modules/binds.lua`
- **Workspaces especiais:** `~/.config/hypr/modules/spaces.lua` (ou Settings na pill)
- **Confere o que está valendo de verdade:**

```sh
hyprctl binds -j | jq -r '.[] | "\(.modmask) \(.key)"'
```

Os bits do `modmask` são `1`=Shift, `4`=Ctrl, `8`=Alt, `64`=Super — `68` é
Super+Ctrl e `69` é Super+Ctrl+Shift, por exemplo.

Depois de editar: `hyprctl reload` (ou `ricelin restart`).