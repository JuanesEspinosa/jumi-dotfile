#!/usr/bin/env bash
# quick-settings.sh — Panel de ajustes rápidos tipo GNOME

ROFI_THEME="$HOME/.config/rofi/quick-settings.rasi"

# ─────────────── Helpers ───────────────────────────────────────────────────────

get_volume() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{printf "%d", $2*100}' || echo "0"
}

is_muted() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | grep -q MUTED && echo yes || echo no
}

get_brightness() {
    brightnessctl -m 2>/dev/null | cut -d',' -f4 | tr -d '%' || echo ""
}

has_backlight() {
    brightnessctl list 2>/dev/null | grep -qi backlight
}

get_wifi() {
    nmcli radio wifi 2>/dev/null | tr -d ' \n' || echo "unknown"
}

get_bluetooth() {
    bluetoothctl show 2>/dev/null | grep -i "Powered:" | awk '{print tolower($2)}' || echo "no"
}

get_theme() {
    cat "$HOME/.config/themes/current" 2>/dev/null || echo "mocha"
}

# ─────────────── Acciones ─────────────────────────────────────────────────────

case "${1:-}" in
    vol-mute) wpctl set-mute   @DEFAULT_AUDIO_SINK@ toggle ;;
    vol-up)   wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ ;;
    vol-down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
    br-up)    brightnessctl set +10% >/dev/null 2>&1 ;;
    br-down)  brightnessctl set 10%- >/dev/null 2>&1 ;;
    wifi)
        [[ "$(get_wifi)" == "enabled" ]] && nmcli radio wifi off || nmcli radio wifi on ;;
    bt)
        [[ "$(get_bluetooth)" == "yes" ]] \
            && bluetoothctl power off >/dev/null 2>&1 \
            || bluetoothctl power on  >/dev/null 2>&1 ;;
    theme)
        exec "$HOME/.local/bin/theme-picker.sh" ;;
esac

# Después de una acción que no sea "theme": reabrir el panel actualizado
[[ "${1:-}" =~ ^(vol|br|wifi|bt) ]] && exec "$0"

# ─────────────── Construir menú ───────────────────────────────────────────────

VOL=$(get_volume)
MUTED=$(is_muted)
BR=$(get_brightness)
WIFI=$(get_wifi)
BT=$(get_bluetooth)
THEME=$(get_theme)

# Volumen
[[ "$MUTED" == "yes" ]] \
    && VOL_LINE="󰝟   Volumen    Silenciado" \
    || VOL_LINE="󰕾   Volumen    ${VOL}%"

# WiFi
[[ "$WIFI" == "enabled" ]] \
    && WIFI_LINE="󰤨   WiFi       Activo" \
    || WIFI_LINE="󰤭   WiFi       Apagado"

# Bluetooth
[[ "$BT" == "yes" ]] \
    && BT_LINE="󰂯   Bluetooth  Activo" \
    || BT_LINE="󰂲   Bluetooth  Apagado"

ITEMS=()
ACTIONS=()

# Sección volumen
ITEMS+=("$VOL_LINE")
ACTIONS+=("vol-mute")
ITEMS+=("      Subir +5%")
ACTIONS+=("vol-up")
ITEMS+=("      Bajar -5%")
ACTIONS+=("vol-down")

# Sección brillo (solo si existe backlight)
if has_backlight && [[ -n "$BR" ]]; then
    ITEMS+=("󰃠   Brillo     ${BR}%")
    ACTIONS+=("")
    ITEMS+=("      Subir +10%")
    ACTIONS+=("br-up")
    ITEMS+=("      Bajar -10%")
    ACTIONS+=("br-down")
fi

# Toggles
ITEMS+=("$WIFI_LINE")
ACTIONS+=("wifi")
ITEMS+=("$BT_LINE")
ACTIONS+=("bt")

# Tema
ITEMS+=("󰏘   Tema       ${THEME}")
ACTIONS+=("theme")

# ─────────────── Lanzar rofi ──────────────────────────────────────────────────

MENU=$(printf '%s\n' "${ITEMS[@]}")
LINES=${#ITEMS[@]}

CHOICE=$(echo "$MENU" | rofi \
    -dmenu \
    -p "" \
    -no-custom \
    -format 'i' \
    -theme "$ROFI_THEME" \
    -theme-str "listview { lines: ${LINES}; }" \
    2>/dev/null) || exit 0

[[ -z "$CHOICE" ]] && exit 0
ACTION="${ACTIONS[$CHOICE]}"
[[ -z "$ACTION" ]] && exit 0

exec "$0" "$ACTION"
