#!/usr/bin/env bash
# theme-picker.sh — selector visual de temas Catppuccin con rofi

THEMES_DIR="$HOME/.config/themes/palettes"
THEME_SWITCH="$HOME/.local/bin/theme-switch.sh"
RASI="$HOME/.config/rofi/theme-picker.rasi"
CURRENT=$(cat "$HOME/.config/themes/current" 2>/dev/null || echo "mocha")

declare -A LABELS=(
    [mocha]="  Mocha"
    [latte]="  Latte"
    [frappe]="  Frappé"
    [macchiato]="  Macchiato"
)

ENTRIES=()
NAMES=()

while IFS= read -r theme; do
    label="${LABELS[$theme]:-   $theme}"
    [[ "$theme" == "$CURRENT" ]] && label="$label  ✓"
    ENTRIES+=("$label")
    NAMES+=("$theme")
done < <(ls "$THEMES_DIR"/*.sh 2>/dev/null | xargs -I{} basename {} .sh | sort)

SELECTION=$(printf '%s\n' "${ENTRIES[@]}" | rofi \
    -dmenu \
    -i \
    -p "󰏘" \
    -theme "$RASI" \
    -mesg "Tema activo: $CURRENT")

[[ -z "$SELECTION" ]] && exit 0

for i in "${!ENTRIES[@]}"; do
    if [[ "${ENTRIES[$i]}" == "$SELECTION" ]]; then
        exec "$THEME_SWITCH" "${NAMES[$i]}"
    fi
done
