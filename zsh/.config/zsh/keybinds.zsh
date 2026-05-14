# keybinds.zsh — atajos de teclado zsh

bindkey -e  # modo emacs (Ctrl+A, Ctrl+E, Ctrl+R, etc.)

# navegacion por palabras
bindkey '^[[1;5C' forward-word   # Ctrl+Derecha
bindkey '^[[1;5D' backward-word  # Ctrl+Izquierda

# borrar palabra anterior
bindkey '^H' backward-kill-word  # Ctrl+Backspace

# inicio y fin de linea
bindkey '^[[H' beginning-of-line  # Home
bindkey '^[[F' end-of-line        # End

# historial con flechas (filtra por lo que ya escribiste)
bindkey '^[[A' history-search-backward  # Arriba
bindkey '^[[B' history-search-forward   # Abajo

# historial
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zsh_history"
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
