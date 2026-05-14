# aliases.zsh — reemplazos modernos

# ls → eza
alias ls='eza --icons'
alias ll='eza --icons -lh --git'
alias la='eza --icons -lah --git'
alias lt='eza --icons --tree --level=2'
alias lta='eza --icons --tree --level=2 -a'

# cat → bat (en Debian se llama batcat)
if command -v batcat &>/dev/null; then
    alias bat='batcat'
fi
alias cat='bat --paging=never'
alias less='bat --paging=always'

# find → fd (en Debian se llama fdfind)
if command -v fdfind &>/dev/null; then
    alias fd='fdfind'
fi

# cd → zoxide
alias cd='z'

# git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# sistema
alias reload='source ~/.zshrc'
alias path='echo $PATH | tr ":" "\n"'
alias ports='ss -tulpn'
alias ip='ip -c'
