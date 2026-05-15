# jumi-dotfile

Dotfiles personales para un escritorio Wayland completo en Debian Trixie.
Hyprland como WM tiling, tema Catppuccin Mocha en todo el sistema, gestionado con GNU Stow.

> **Repo:** github.com/JuanesEspinosa/jumi-dotfile

---

## Stack

| Componente | Herramienta |
|---|---|
| **Compositor / WM** | Hyprland ≥ 0.54 |
| **Barra de estado** | Waybar |
| **Terminal** | kitty |
| **Shell** | zsh + zinit + starship |
| **Multiplexor** | tmux |
| **Launcher** | wofi |
| **Notificaciones** | dunst |
| **Screenshotter** | grim + slurp + swappy |
| **Power menu** | wlogout |
| **File manager GUI** | nautilus |
| **File manager TUI** | yazi |
| **Audio** | PipeWire + easyeffects |
| **Wallpaper** | swww |
| **Lock screen** | hyprlock + hypridle |
| **Tema** | Catppuccin Mocha |
| **Fuente** | JetBrainsMono Nerd Font |
| **Gestión dotfiles** | GNU Stow + Git |

---

## Instalación rápida

```bash
git clone https://github.com/JuanesEspinosa/jumi-dotfile.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

El script instala paquetes, aplica stow, descarga yazi y genera el tema inicial.
Requiere que Hyprland ya esté instalado (usa el script de JaKooLit).

### Manual (paso a paso)

```bash
# 1. Clonar
git clone https://github.com/JuanesEspinosa/jumi-dotfile.git ~/dotfiles
cd ~/dotfiles

# 2. Dependencias
sudo apt install stow waybar wofi dunst kitty zsh tmux \
  grim slurp swappy wlogout nautilus easyeffects \
  fzf ripgrep fd-find bat eza zoxide

# 3. Aplicar paquetes stow
stow hyprland kitty zsh tmux starship waybar wofi themes swappy wlogout yazi

# 4. Yazi — no está en repos de Trixie, instalar desde github.com/sxyazi/yazi/releases

# 5. Tema inicial
theme-switch.sh mocha
```

---

## Estructura

```
dotfiles/
├── hyprland/       # Config modular de Hyprland
│   └── .config/hypr/
│       ├── hyprland.conf
│       └── conf/
│           ├── keybinds.conf
│           ├── monitors.conf
│           ├── input.conf
│           ├── decoration.conf
│           ├── animations.conf
│           ├── autostart.conf
│           ├── environment.conf
│           └── windowrules.conf
├── waybar/         # Barra con chips Catppuccin
│   └── .config/waybar/
│       ├── config.jsonc
│       ├── style.css
│       └── modules/
│           ├── volume-control.sh   # Switcher de dispositivos + wofi
│           └── power-menu.sh       # Llama a wlogout
├── kitty/          # Terminal con transparencia 0.88
├── zsh/            # .zshrc modular (exports, aliases, functions, keybinds)
├── tmux/           # Prefijo C-a, splits, vim nav
├── starship/       # Prompt Catppuccin
├── wofi/           # Launcher (600x400, center, drun)
├── themes/         # Sistema de paletas Catppuccin
│   └── .config/themes/
│       ├── palettes/mocha.sh
│       └── generators/
├── swappy/         # Config de anotaciones de screenshots
├── wlogout/        # Power menu con 5 botones + tema Catppuccin
├── yazi/           # File manager TUI con tema Catppuccin Mocha
├── install.sh      # Bootstrap automático
└── .gitignore
```

---

## Keybinds

### Aplicaciones
| Keybind | Acción |
|---|---|
| `SUPER + Return` | Terminal (kitty) |
| `ALT + Space` | App launcher (wofi) |
| `SUPER + E` | Nautilus |
| `SUPER + SHIFT + E` | Yazi en kitty |
| `SUPER + A` | EasyEffects |

### Capturas de pantalla
| Keybind | Acción |
|---|---|
| `Print` | Seleccionar región → swappy |
| `SHIFT + Print` | Pantalla completa → swappy |

### Ventanas
| Keybind | Acción |
|---|---|
| `SUPER + Q` | Cerrar ventana |
| `SUPER + F` | Pantalla completa |
| `SUPER + T` | Toggle floating |
| `SUPER + H/J/K/L` | Mover foco (vim-style) |
| `SUPER + SHIFT + H/J/K/L` | Mover ventana |
| `SUPER + CTRL + H/J/K/L` | Redimensionar |

### Workspaces
| Keybind | Acción |
|---|---|
| `SUPER + 1-9` | Ir a workspace |
| `SUPER + SHIFT + 1-9` | Mover ventana a workspace |
| `SUPER + scroll` | Navegar workspaces |

### Sistema
| Keybind | Acción |
|---|---|
| `SUPER + SHIFT + R` | Recargar Hyprland |
| `SUPER + SHIFT + T` | Tema Catppuccin Mocha |
| `SUPER + SHIFT + Y` | Tema Catppuccin Latte |

### Power menu (wlogout)
`l` bloquear · `e` cerrar sesión · `u` suspender · `r` reiniciar · `s` apagar

---

## Waybar

```
[workspaces] [ventana]    [hora · día fecha]    [°C] [CPU%] [RAM] [red] [vol] [tray] [⏻]
```

- **Click izquierdo volumen** → mute/unmute
- **Click derecho volumen** → menú (dispositivos, mic, EasyEffects)
- **Scroll volumen** → ±5%
- **Click power** → wlogout overlay

---

## Tema

```bash
theme-switch.sh mocha   # Catppuccin Mocha (oscuro)
theme-switch.sh latte   # Catppuccin Latte (claro) — pendiente
```

Aplica a: Hyprland · Waybar · kitty · wofi · dunst
