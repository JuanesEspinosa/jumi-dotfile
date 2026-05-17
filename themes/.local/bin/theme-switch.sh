#!/usr/bin/env bash
# theme-switch.sh — aplica un tema completo al entorno
# Uso: theme-switch.sh mocha | latte | tokyo-night

set -euo pipefail

THEMES_DIR="$HOME/.config/themes"
PALETTE="$THEMES_DIR/palettes/${1:-mocha}.sh"

if [[ ! -f "$PALETTE" ]]; then
  echo "Error: paleta '$1' no encontrada en $THEMES_DIR/palettes/"
  echo "Disponibles: $(ls "$THEMES_DIR/palettes/" | sed 's/.sh//' | tr '\n' ' ')"
  exit 1
fi

echo "→ Aplicando tema: ${1:-mocha}"

# 1. Cargar paleta
source "$PALETTE"

# 2. Registrar tema activo
echo "${1:-mocha}" > "$THEMES_DIR/current"

# 3. Generar TODOS los archivos de config ANTES de recargar daemons
source "$THEMES_DIR/generators/hyprland.sh"
source "$THEMES_DIR/generators/kitty.sh"
source "$THEMES_DIR/generators/waybar.sh"
source "$THEMES_DIR/generators/wofi.sh"
source "$THEMES_DIR/generators/dunst.sh"
source "$THEMES_DIR/generators/rofi.sh"

# 4. GTK theming (antes de hyprctl reload para que no mate el proceso)
GTK_THEME_NAME="catppuccin-${1:-mocha}-mauve"
GTK_THEME_DIR="$HOME/.local/share/themes/$GTK_THEME_NAME"

if [[ -d "$GTK_THEME_DIR" ]]; then
  PREFER_DARK="false"
  COLOR_SCHEME="prefer-light"
  if [[ "$THEME_VARIANT" != "light" ]]; then
    PREFER_DARK="true"
    COLOR_SCHEME="prefer-dark"
  fi

  GTK4_CONFIG="$HOME/.config/gtk-4.0"
  mkdir -p "$GTK4_CONFIG"
  cat > "$GTK4_CONFIG/settings.ini" << SETTINGS
[Settings]
gtk-application-prefer-dark-theme=${PREFER_DARK}
gtk-cursor-theme-name=Bibata-Modern-Classic
gtk-cursor-theme-size=24
gtk-decoration-layout=icon:minimize,maximize,close
gtk-enable-animations=true
gtk-font-name=JetBrainsMono Nerd Font 11
gtk-icon-theme-name=Papirus-Dark
gtk-theme-name=${GTK_THEME_NAME}
SETTINGS

  cp "$GTK_THEME_DIR/gtk-4.0/gtk.css"      "$GTK4_CONFIG/gtk.css"
  cp "$GTK_THEME_DIR/gtk-4.0/gtk-dark.css" "$GTK4_CONFIG/gtk-dark.css"
  rm -rf "$GTK4_CONFIG/assets"
  cp -r  "$GTK_THEME_DIR/gtk-4.0/assets"   "$GTK4_CONFIG/assets"
  # Toggle color-scheme por "default" primero para forzar señal dconf aunque
  # el valor destino sea el mismo que ya habia (libadwaita no reacciona si no hay cambio)
  gsettings set org.gnome.desktop.interface color-scheme "default"           2>/dev/null || true
  gsettings set org.gnome.desktop.interface color-scheme "$COLOR_SCHEME"     2>/dev/null || true
  gsettings set org.gnome.desktop.interface gtk-theme    "$GTK_THEME_NAME"   2>/dev/null || true
  gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Classic" 2>/dev/null || true
  gsettings set org.gnome.desktop.interface cursor-size  24                  2>/dev/null || true

  # gtk-3.0 settings (puede sobreescribir cursor si tiene valores viejos de KDE)
  mkdir -p "$HOME/.config/gtk-3.0"
  cat > "$HOME/.config/gtk-3.0/settings.ini" << GTKEOF
[Settings]
gtk-application-prefer-dark-theme=${PREFER_DARK}
gtk-cursor-theme-name=Bibata-Modern-Classic
gtk-cursor-theme-size=24
gtk-decoration-layout=icon:minimize,maximize,close
gtk-enable-animations=true
gtk-font-name=JetBrainsMono Nerd Font 11
gtk-icon-theme-name=Papirus-Dark
gtk-theme-name=${GTK_THEME_NAME}
GTKEOF

  # gtkrc-2.0 (GTK2 legacy)
  cat > "$HOME/.gtkrc-2.0" << GTKEOF
gtk-cursor-theme-name="Bibata-Modern-Classic"
gtk-cursor-theme-size=24
gtk-theme-name="${GTK_THEME_NAME}"
gtk-icon-theme-name="Papirus-Dark"
gtk-font-name="JetBrainsMono Nerd Font 11"
GTKEOF

  echo "  ✓ GTK theme aplicado (prefer-dark=${PREFER_DARK})"
else
  echo "  ⚠ Tema GTK '$GTK_THEME_NAME' no instalado — instala con install.sh"
fi

# 5. Kvantum — cambiar tema Qt
KVANTUM_THEME="catppuccin-${1:-mocha}-mauve"
if [[ -d "$HOME/.config/Kvantum/$KVANTUM_THEME" ]]; then
  kvantummanager --set "$KVANTUM_THEME" 2>/dev/null || true
  echo "  ✓ Kvantum theme: $KVANTUM_THEME"
else
  echo "  ⚠ Kvantum theme '$KVANTUM_THEME' no instalado"
fi

# 7. Recargar Hyprland (puede matar el proceso en algunos contextos — va al final)
hyprctl reload

# 8. Recargar daemons
pkill -SIGUSR1 kitty 2>/dev/null || true

if pgrep -x waybar > /dev/null; then
  pkill waybar && waybar &
fi

if pgrep -x dunst > /dev/null; then
  pkill dunst && dunst &
fi

# 9. Cerrar Nautilus para que recargue CSS de GTK4 desde disco al reabrir
# libadwaita aplica gtk-dark.css sobre el gtk.css cacheado en memoria al
# volver a modo oscuro — kill fuerza relectura completa al próximo launch
if pgrep -f "nautilus" > /dev/null 2>&1; then
  nautilus -q 2>/dev/null || pkill -f nautilus 2>/dev/null || true
  echo "  ✓ Nautilus cerrado (reabrirlo para ver el tema nuevo)"
fi

echo "✓ Tema '${1:-mocha}' aplicado correctamente"
