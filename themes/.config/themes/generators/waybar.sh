#!/usr/bin/env bash
# Genera ~/.config/waybar/themes/current.css desde la paleta activa
# Requiere que las variables de paleta esten cargadas en el entorno

OUTPUT="$HOME/.config/waybar/themes/current.css"
mkdir -p "$(dirname "$OUTPUT")"

cat > "$OUTPUT" << EOF
/* Tema generado automaticamente — NO editar manualmente */
@define-color base       ${BASE};
@define-color mantle     ${MANTLE};
@define-color crust      ${CRUST};
@define-color surface0   ${SURFACE0};
@define-color surface1   ${SURFACE1};
@define-color text       ${TEXT};
@define-color subtext0   ${SUBTEXT0};
@define-color accent     ${ACCENT};
@define-color accent_alt ${ACCENT_ALT};
@define-color warning    ${WARNING};
@define-color critical   ${CRITICAL};
@define-color success    ${SUCCESS};
@define-color bar_bg     ${BASE};
@define-color bar_border ${SURFACE0};
@define-color module_bg  ${MANTLE};
@define-color text_muted ${SUBTEXT0};
EOF

echo "  ✓ Waybar theme generado"
