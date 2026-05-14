# exports.zsh — variables de entorno y PATH

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="bat --paging=always"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# PATH
export PATH="$HOME/.local/bin:$PATH"

# fzf — usar ripgrep como fuente, ignorar .git y node_modules
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git" --glob "!node_modules"'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# bat — tema Catppuccin
export BAT_THEME="Catppuccin Mocha"

# zoxide
export _ZO_ECHO=1
