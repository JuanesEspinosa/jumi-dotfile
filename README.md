# jumi-dotfile

Dotfiles personales para Hyprland en Debian Trixie, gestionados con GNU Stow.

## Stack

- **WM:** Hyprland
- **Barra:** Waybar
- **Terminal:** kitty + zsh (zinit) + tmux + starship
- **Launcher:** wofi
- **Notificaciones:** dunst
- **Tema:** Catppuccin Mocha
- **Fuente:** JetBrainsMono Nerd Font
- **Gestión:** GNU Stow
- **Repo:** github.com/JuanesEspinosa/jumi-dotfile

## Estructura

```
dotfiles/
├── hyprland/   # Hyprland config modular
├── kitty/      # kitty terminal
├── zsh/        # zsh + zinit modular
├── tmux/       # tmux config
├── starship/   # starship prompt
├── waybar/     # barra de estado
├── wofi/       # launcher
├── themes/     # sistema de temas Catppuccin
└── .gitignore
```

## Instalación

```bash
git clone https://github.com/JuanesEspinosa/jumi-dotfile.git ~/dotfiles
cd ~/dotfiles
stow hyprland kitty zsh tmux starship waybar wofi themes
theme-switch.sh mocha
```
