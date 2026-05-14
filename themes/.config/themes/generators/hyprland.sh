#!/usr/bin/env bash
# Genera ~/.config/hypr/themes/current.conf desde la paleta activa
# Requiere que las variables de paleta esten cargadas en el entorno

OUTPUT="$HOME/.config/hypr/themes/current.conf"
mkdir -p "$(dirname "$OUTPUT")"

cat > "$OUTPUT" << EOF
# Tema generado automaticamente — NO editar manualmente
# Generado: $(date)
# Paleta: $THEME_NAME

\$base       = rgb(${BASE//#/})
\$mantle     = rgb(${MANTLE//#/})
\$crust      = rgb(${CRUST//#/})
\$surface0   = rgb(${SURFACE0//#/})
\$surface1   = rgb(${SURFACE1//#/})
\$text       = rgb(${TEXT//#/})
\$accent     = rgb(${ACCENT//#/})
\$accent_alt = rgb(${ACCENT_ALT//#/})
\$red        = rgb(${RED//#/})
\$green      = rgb(${GREEN//#/})
\$yellow     = rgb(${YELLOW//#/})
\$mauve      = rgb(${MAUVE//#/})
\$shadow     = rgba(${CRUST//#/}ee)
EOF

echo "  ✓ Hyprland theme generado"
