# functions.zsh — funciones utiles

# mkcd — crear directorio y entrar
mkcd() { mkdir -p "$1" && cd "$1" }

# fh — buscar en historial con fzf y ejecutar
fh() {
    local cmd
    cmd=$(history | fzf --tac --no-sort | sed 's/^[[:space:]]*[0-9]*[[:space:]]*//')
    [[ -n "$cmd" ]] && eval "$cmd"
}

# proj — ir a directorio de proyecto con fzf
proj() {
    local dir
    dir=$(fd --type d --max-depth 3 . ~/Documentos ~/dotfiles 2>/dev/null | fzf --preview 'eza --tree --level=1 --color=always {}')
    [[ -n "$dir" ]] && cd "$dir"
}

# t — crear o adjuntar sesion de tmux por nombre
t() {
    local session="${1:-main}"
    tmux new-session -A -s "$session"
}

# extract — descomprimir cualquier formato
extract() {
    case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz)  tar xzf "$1" ;;
        *.tar.xz)  tar xJf "$1" ;;
        *.zip)     unzip "$1" ;;
        *.gz)      gunzip "$1" ;;
        *.7z)      7z x "$1" ;;
        *)         echo "Formato no soportado: $1" ;;
    esac
}
