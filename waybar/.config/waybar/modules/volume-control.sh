#!/usr/bin/env bash
# Control de volumen completo — dispositivos, volumen y micrófono

VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%.0f", $2 * 100}')
MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -c MUTED || true)
MIC_MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | grep -c MUTED || true)
DEFAULT_SINK=$(pactl get-default-sink)

get_sink_desc() {
  pactl list sinks | grep -A 50 "Name: $1" | grep "device.description" | head -1 | sed 's/.*= "\(.*\)"/\1/'
}

# Opciones de mute/mic
[ "$MUTED" -gt 0 ]     && MUTE_LINE="󰕾  Activar sonido"     || MUTE_LINE="󰝟  Silenciar"
[ "$MIC_MUTED" -gt 0 ] && MIC_LINE="󰍬  Micrófono: Activar" || MIC_LINE="󰍭  Micrófono: Silenciar"

# Construir lista de sinks y mapa desc → nombre
declare -A SINK_MAP
SINK_LINES=""
while read -r line; do
  sname=$(awk '{print $2}' <<< "$line")
  sdesc=$(get_sink_desc "$sname")
  [ -z "$sdesc" ] && sdesc="$sname"
  SINK_MAP["$sdesc"]="$sname"
  [ "$sname" = "$DEFAULT_SINK" ] \
    && SINK_LINES+="󰓃  ●  ${sdesc}\n" \
    || SINK_LINES+="󰓃  ○  ${sdesc}\n"
done < <(pactl list sinks short)

# Menú completo
MENU=$(printf '%s\n' \
  "$MUTE_LINE" \
  "󰝝  Volumen +10%" \
  "󰝞  Volumen -10%" \
  "  25%   •   50%   •   75%   •   100%" \
  "────────────────────────────────" \
)
MENU+=$(echo -e "$SINK_LINES")
MENU+=$(printf '\n%s\n%s\n%s\n' "────────────────────────────────" "$MIC_LINE" "󰺢  Abrir EasyEffects")

CHOSEN=$(echo "$MENU" | wofi --dmenu \
  --prompt "  Volumen: ${VOL}%" \
  --width 340 \
  --cache-file /dev/null \
  --insensitive)

[ -z "$CHOSEN" ] && exit 0

case "$CHOSEN" in
  *"Activar sonido"*|*"Silenciar"*)
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
  *"+10%"*)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+ ;;
  *"-10%"*)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%- ;;
  *"25%"*)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.25 ;;
  *"50%"*)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.50 ;;
  *"75%"*)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.75 ;;
  *"100%"*)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 1.0 ;;
  *"Micrófono"*)
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle ;;
  *"EasyEffects"*)
    easyeffects & ;;
  *"●"*|*"○"*)
    # Cambiar dispositivo de salida
    DESC=$(echo "$CHOSEN" | sed 's/󰓃  [●○]  //')
    SINK="${SINK_MAP[$DESC]}"
    if [ -n "$SINK" ]; then
      pactl set-default-sink "$SINK"
      pactl list sink-inputs short | awk '{print $1}' | while read -r id; do
        pactl move-sink-input "$id" "$SINK" 2>/dev/null
      done
    fi
    ;;
esac
