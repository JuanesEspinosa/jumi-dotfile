#!/usr/bin/env bash
# Genera ~/.config/wofi/style.css desde la paleta activa
# Requiere que las variables de paleta esten cargadas en el entorno

OUTPUT="$HOME/.config/wofi/style.css"
mkdir -p "$(dirname "$OUTPUT")"

cat > "$OUTPUT" << EOF
/* Tema generado automaticamente — NO editar manualmente */
window {
  background-color: ${BASE};
  border: 2px solid ${ACCENT};
  border-radius: 12px;
}

#input {
  background-color: ${MANTLE};
  color: ${TEXT};
  border: 1px solid ${SURFACE0};
  border-radius: 8px;
  padding: 8px 12px;
  margin: 8px;
}

#inner-box {
  background-color: ${BASE};
}

#outer-box {
  padding: 8px;
}

#scroll {
  margin: 4px;
}

#text {
  color: ${TEXT};
  padding: 4px 8px;
}

#entry {
  border-radius: 8px;
  padding: 4px;
}

#entry:selected {
  background-color: ${SURFACE0};
}

#entry:selected #text {
  color: ${ACCENT};
}
EOF

echo "  ✓ Wofi theme generado"
