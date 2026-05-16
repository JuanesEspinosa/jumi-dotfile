#!/usr/bin/env bash
# Genera ~/.config/rofi/catppuccin-current.rasi desde la paleta activa
# Requiere que las variables de paleta esten cargadas en el entorno

OUTPUT="$HOME/.config/rofi/catppuccin-current.rasi"
mkdir -p "$(dirname "$OUTPUT")"

# fg1 usa SUBTEXT0 para placeholders — contraste adecuado en temas claros y oscuros
# Mocha: #a6adc8 sobre #181825 (buen contraste, gris claro sobre negro)
# Latte: #5c5f77 sobre #e6e9ef (buen contraste, gris oscuro sobre blanco)

cat > "$OUTPUT" << EOF
/* Tema generado automaticamente — NO editar manualmente */
/* Generado: $(date) | Paleta: $THEME_NAME */

* {
    bg0:    ${BASE};
    bg1:    ${MANTLE};
    bg2:    ${SURFACE0};
    bg3:    ${SURFACE1};
    fg0:    ${TEXT};
    fg1:    ${SUBTEXT0};
    accent: ${ACCENT};
    urgent: ${RED};

    background-color: transparent;
    text-color:       @fg0;
    border-color:     @bg2;
    font:             "JetBrainsMono Nerd Font 13";
}

window {
    background-color: @bg0;
    border:           2px solid;
    border-color:     @bg2;
    border-radius:    12px;
    width:            360px;
    padding:          12px;
}

mainbox {
    background-color: transparent;
    children:         [ inputbar, listview ];
    spacing:          8px;
}

inputbar {
    background-color: @bg1;
    border-radius:    8px;
    padding:          10px 14px;
    children:         [ prompt, entry ];
    spacing:          8px;
}

prompt {
    text-color: @accent;
}

entry {
    text-color:        @fg0;
    placeholder:       "Buscar...";
    placeholder-color: @fg1;
}

listview {
    background-color: transparent;
    lines:            8;
    spacing:          2px;
    scrollbar:        false;
    fixed-height:     false;
}

element {
    background-color: transparent;
    border-radius:    8px;
    padding:          10px 14px;
}

element-text {
    background-color: transparent;
    text-color:       @fg0;
    vertical-align:   0.5;
}

element.normal.normal    { background-color: transparent; }
element.alternate.normal { background-color: transparent; }

element.selected.normal {
    background-color: @bg2;
}

element-text.selected.normal {
    text-color: @accent;
}

element.normal.urgent    { background-color: transparent; }
element-text.normal.urgent  { text-color: @urgent; }
element.selected.urgent  { background-color: @bg2; }
EOF

echo "  ✓ Rofi theme generado"
