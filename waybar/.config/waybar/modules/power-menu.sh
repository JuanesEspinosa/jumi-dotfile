#!/usr/bin/env bash
# Menú de power — usa wofi si está disponible, si no rofi

options="󰐥  Apagar\n󰜉  Reiniciar\n󰒲  Suspender\n󰍃  Cerrar sesion"

if command -v wofi &>/dev/null; then
  chosen=$(echo -e "$options" | wofi --dmenu \
    --prompt "Power" \
    --lines 4 \
    --width 220 \
    --cache-file /dev/null)
elif command -v rofi &>/dev/null; then
  chosen=$(echo -e "$options" | rofi -dmenu \
    -p "Power" \
    -lines 4 \
    -width 220)
else
  exit 1
fi

case "$chosen" in
  *Apagar*)          systemctl poweroff ;;
  *Reiniciar*)       systemctl reboot ;;
  *Suspender*)       systemctl suspend ;;
  *"Cerrar sesion"*) hyprctl dispatch exit ;;
esac
