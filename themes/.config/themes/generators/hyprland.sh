#!/usr/bin/env bash
# Genera ~/.config/hypr/themes/current.conf desde la paleta activa
# Requiere que las variables de paleta esten cargadas en el entorno

OUTPUT="$HOME/.config/hypr/themes/current.conf"
mkdir -p "$(dirname "$OUTPUT")"

# Temp en el mismo directorio para que mv sea atomico (mismo filesystem)
# Evita que inotify de Hyprland detecte el archivo a medias durante la escritura
TEMP="$(mktemp -p "$(dirname "$OUTPUT")")"

cat > "$TEMP" << EOF
# Tema generado automaticamente — NO editar manualmente
# Generado: $(date)
# Paleta: $THEME_NAME

\$base       = rgb(${BASE#\#})
\$mantle     = rgb(${MANTLE#\#})
\$crust      = rgb(${CRUST#\#})
\$surface0   = rgb(${SURFACE0#\#})
\$surface1   = rgb(${SURFACE1#\#})
\$text       = rgb(${TEXT#\#})
\$accent     = rgb(${ACCENT#\#})
\$accent_alt = rgb(${ACCENT_ALT#\#})
\$red        = rgb(${RED#\#})
\$green      = rgb(${GREEN#\#})
\$yellow     = rgb(${YELLOW#\#})
\$mauve      = rgb(${MAUVE#\#})
\$shadow     = rgba(${CRUST#\#}ee)

# Variantes Alpha (hex crudo sin rgb() — para rgba() en borders y gradientes)
\$accentAlpha     = ${ACCENT#\#}
\$accent_altAlpha = ${ACCENT_ALT#\#}
\$surface0Alpha   = ${SURFACE0#\#}

# GTK_THEME aqui (no en environment.conf) para que hyprctl reload lo actualice
env = GTK_THEME,catppuccin-${THEME_NAME}-mauve
EOF

mv "$TEMP" "$OUTPUT"
echo "  ✓ Hyprland theme generado"
