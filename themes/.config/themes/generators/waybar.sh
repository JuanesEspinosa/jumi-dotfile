#!/usr/bin/env bash
# Genera ~/.config/waybar/themes/current.css desde la paleta activa
# Requiere que las variables de paleta esten cargadas en el entorno

OUTPUT="$HOME/.config/waybar/themes/current.css"
mkdir -p "$(dirname "$OUTPUT")"

cat > "$OUTPUT" << EOF
/* Tema generado automaticamente — NO editar manualmente */
:root {
  --base:       ${BASE};
  --mantle:     ${MANTLE};
  --crust:      ${CRUST};
  --surface0:   ${SURFACE0};
  --surface1:   ${SURFACE1};
  --text:       ${TEXT};
  --subtext0:   ${SUBTEXT0};
  --accent:     ${ACCENT};
  --accent-alt: ${ACCENT_ALT};
  --warning:    ${WARNING};
  --critical:   ${CRITICAL};
  --success:    ${SUCCESS};
  --bar-bg:       ${BASE};
  --bar-border:   ${SURFACE0};
  --module-bg:    ${MANTLE};
  --module-hover: ${SURFACE0};
  --text-primary: ${TEXT};
  --text-muted:   ${SUBTEXT0};
}
EOF

echo "  ✓ Waybar theme generado"
