#!/usr/bin/env bash
# Menú de power via wofi --dmenu

options="󰐥  Apagar\n󰜉  Reiniciar\n󰒲  Suspender\n󰍃  Cerrar sesion"

chosen=$(echo -e "$options" | wofi --dmenu \
  --prompt "Power" \
  --lines 4 \
  --width 220 \
  --height 180 \
  --cache-file /dev/null)

case "$chosen" in
  *Apagar*)        systemctl poweroff ;;
  *Reiniciar*)     systemctl reboot ;;
  *Suspender*)     systemctl suspend ;;
  *"Cerrar sesion"*) hyprctl dispatch exit ;;
esac
