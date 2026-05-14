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

# 3. Generar config de Hyprland
source "$THEMES_DIR/generators/hyprland.sh"
hyprctl reload

# 4. Generar tema de kitty y recargar instancias
source "$THEMES_DIR/generators/kitty.sh"
pkill -SIGUSR1 kitty 2>/dev/null || true

# 5. Generar CSS de Waybar (se aplica al proximo inicio de waybar)
source "$THEMES_DIR/generators/waybar.sh"
if pgrep -x waybar > /dev/null; then
  pkill waybar && waybar &
fi

# 6. Generar configs de wofi y dunst (se aplican al proximo launch)
source "$THEMES_DIR/generators/wofi.sh"
source "$THEMES_DIR/generators/dunst.sh"
if pgrep -x dunst > /dev/null; then
  pkill dunst && dunst &
fi

echo "✓ Tema '${1:-mocha}' aplicado correctamente"
