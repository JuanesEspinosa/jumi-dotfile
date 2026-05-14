#!/usr/bin/env bash
# Genera ~/.config/kitty/themes/current.conf desde la paleta activa
# Requiere que las variables de paleta esten cargadas en el entorno

OUTPUT="$HOME/.config/kitty/themes/current.conf"
mkdir -p "$(dirname "$OUTPUT")"

cat > "$OUTPUT" << EOF
# Tema generado automaticamente — NO editar manualmente
# Generado: $(date)
# Paleta: $THEME_NAME

foreground           ${TEXT}
background           ${BASE}
selection_foreground ${BASE}
selection_background ${ROSEWATER}

cursor               ${ROSEWATER}
cursor_text_color    ${BASE}

url_color            ${ROSEWATER}

color0  ${SURFACE1}
color1  ${RED}
color2  ${GREEN}
color3  ${YELLOW}
color4  ${BLUE}
color5  ${PINK}
color6  ${TEAL}
color7  ${SUBTEXT1}

color8  ${SURFACE2}
color9  ${RED}
color10 ${GREEN}
color11 ${YELLOW}
color12 ${BLUE}
color13 ${PINK}
color14 ${TEAL}
color15 ${SUBTEXT0}
EOF

echo "  ✓ Kitty theme generado"
