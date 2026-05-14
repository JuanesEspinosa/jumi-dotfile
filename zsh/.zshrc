# .zshrc — punto de entrada

# ── Zinit ──────────────────────────────────────────────────────────────────
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"
source "$ZINIT_HOME/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# ── Plugins ────────────────────────────────────────────────────────────────
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light Aloxaf/fzf-tab

# ── Modulos propios ────────────────────────────────────────────────────────
ZSH_CONFIG="$HOME/.config/zsh"
for module in exports aliases functions keybinds; do
    [[ -f "$ZSH_CONFIG/$module.zsh" ]] && source "$ZSH_CONFIG/$module.zsh"
done

# ── Completado ─────────────────────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --level=1 --color=always $realpath'

# ── Herramientas externas ──────────────────────────────────────────────────
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
source <(fzf --zsh)
