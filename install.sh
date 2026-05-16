#!/usr/bin/env bash
# install.sh — Bootstrap de dotfiles jumi en Debian Trixie
# Uso: bash install.sh
# Seguro de correr múltiples veces (idempotente)

set -euo pipefail

# ── Colores ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'

log()   { echo -e "${BLUE}${BOLD}[·]${NC} $1"; }
ok()    { echo -e "${GREEN}${BOLD}[✓]${NC} $1"; }
warn()  { echo -e "${YELLOW}${BOLD}[!]${NC} $1"; }
error() { echo -e "${RED}${BOLD}[✗]${NC} $1"; exit 1; }
header(){ echo -e "\n${BOLD}${BLUE}━━━ $1 ━━━${NC}"; }

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Verificar Debian ──────────────────────────────────────────────────────────
header "Verificando sistema"
[[ -f /etc/debian_version ]] || error "Este script requiere Debian/Ubuntu"
ok "Debian detectado: $(cat /etc/debian_version)"

# ── Paquetes APT ─────────────────────────────────────────────────────────────
header "Instalando paquetes"

APT_PACKAGES=(
  # Gestión
  stow git

  # Terminal
  kitty zsh tmux

  # Shell tools
  fzf ripgrep fd-find bat eza zoxide

  # WM / Display
  waybar wofi dunst
  grim slurp swappy
  wlogout
  hyprlock hypridle

  # Audio
  pipewire wireplumber
  pavucontrol easyeffects

  # Archivos
  nautilus

  # Temas GTK e iconos
  papirus-icon-theme

  # Fuentes
  fonts-jetbrains-mono

  # Utilidades
  curl wget unzip jq
  xdg-utils playerctl
  brightnessctl
)

log "Actualizando lista de paquetes..."
sudo apt-get update -qq

MISSING=()
for pkg in "${APT_PACKAGES[@]}"; do
  dpkg -s "$pkg" &>/dev/null || MISSING+=("$pkg")
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
  log "Instalando: ${MISSING[*]}"
  sudo apt-get install -y "${MISSING[@]}"
  ok "Paquetes instalados"
else
  ok "Todos los paquetes APT ya están instalados"
fi

# ── Waypaper ──────────────────────────────────────────────────────────────────
header "Waypaper (selector de fondos)"
if ! command -v waypaper &>/dev/null; then
  log "Instalando waypaper..."
  pip3 install --user --break-system-packages waypaper
  ok "Waypaper instalado"
else
  ok "Waypaper ya instalado: $(waypaper --version 2>/dev/null)"
fi

# ── Starship ──────────────────────────────────────────────────────────────────
header "Starship prompt"
if ! command -v starship &>/dev/null; then
  log "Instalando starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
  ok "Starship instalado"
else
  ok "Starship ya instalado: $(starship --version)"
fi

# ── Yazi ─────────────────────────────────────────────────────────────────────
header "Yazi (file manager)"
if ! command -v yazi &>/dev/null; then
  log "Descargando yazi (última versión)..."
  YAZI_URL=$(curl -s https://api.github.com/repos/sxyazi/yazi/releases/latest \
    | grep "browser_download_url.*x86_64-unknown-linux-gnu.zip" \
    | cut -d'"' -f4)

  if [[ -z "$YAZI_URL" ]]; then
    warn "No se pudo obtener URL de yazi — instálalo manualmente desde github.com/sxyazi/yazi"
  else
    wget -qO /tmp/yazi.zip "$YAZI_URL"
    unzip -o /tmp/yazi.zip -d /tmp/yazi-bin
    sudo mv /tmp/yazi-bin/yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin/
    sudo mv /tmp/yazi-bin/yazi-x86_64-unknown-linux-gnu/ya   /usr/local/bin/
    rm -rf /tmp/yazi.zip /tmp/yazi-bin
    ok "Yazi instalado: $(yazi --version)"
  fi
else
  ok "Yazi ya instalado: $(yazi --version)"
fi

# ── Fuente JetBrainsMono Nerd Font ────────────────────────────────────────────
header "Fuentes"
FONT_DIR="$HOME/.local/share/fonts"
if fc-list | grep -qi "JetBrainsMono Nerd Font"; then
  ok "JetBrainsMono Nerd Font ya instalada"
else
  log "Instalando JetBrainsMono Nerd Font..."
  mkdir -p "$FONT_DIR"
  FONT_URL=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest \
    | grep "browser_download_url.*JetBrainsMono.tar.xz" \
    | cut -d'"' -f4)
  if [[ -n "$FONT_URL" ]]; then
    wget -qO /tmp/JetBrainsMono.tar.xz "$FONT_URL"
    tar -xf /tmp/JetBrainsMono.tar.xz -C "$FONT_DIR"
    rm /tmp/JetBrainsMono.tar.xz
    fc-cache -f
    ok "JetBrainsMono Nerd Font instalada"
  else
    warn "No se pudo descargar la fuente — instálala manualmente"
  fi
fi

# ── Directorios ───────────────────────────────────────────────────────────────
header "Directorios"
mkdir -p "$HOME/Pictures/Screenshots"
mkdir -p "$HOME/.local/bin"
ok "Directorios creados"

# ── GNU Stow ──────────────────────────────────────────────────────────────────
header "Aplicando paquetes stow"

STOW_PACKAGES=(
  hyprland kitty zsh tmux starship
  waybar wofi themes rofi
  swappy wlogout yazi waypaper
)

cd "$DOTFILES_DIR"
for pkg in "${STOW_PACKAGES[@]}"; do
  if [[ -d "$pkg" ]]; then
    stow --restow "$pkg" 2>/dev/null && ok "stow: $pkg" || warn "stow: $pkg (revisa conflictos)"
  else
    warn "Paquete no encontrado: $pkg"
  fi
done

# ── Shell por defecto ─────────────────────────────────────────────────────────
header "Shell"
ZSH_PATH=$(which zsh)
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
  log "Cambiando shell a zsh..."
  chsh -s "$ZSH_PATH"
  ok "Shell cambiado a zsh (efectivo en próximo login)"
else
  ok "zsh ya es el shell por defecto"
fi

# ── Tema inicial ──────────────────────────────────────────────────────────────
header "Tema Catppuccin Mocha"
THEME_SCRIPT="$HOME/.local/bin/theme-switch.sh"
if [[ -x "$THEME_SCRIPT" ]]; then
  log "Generando tema Catppuccin Mocha..."
  "$THEME_SCRIPT" mocha
  ok "Tema aplicado"
else
  warn "theme-switch.sh no encontrado — aplica stow themes primero"
fi

# ── GTK Theming ───────────────────────────────────────────────────────────────
header "GTK Theming (Catppuccin — Mocha y Latte)"

install_gtk_flavor() {
  local FLAVOR="$1"
  local THEME_DIR="$HOME/.local/share/themes/catppuccin-${FLAVOR}-mauve"
  if [[ ! -d "$THEME_DIR" ]]; then
    log "Descargando tema GTK Catppuccin ${FLAVOR^} Mauve..."
    GTK_URL=$(curl -s https://api.github.com/repos/catppuccin/gtk/releases/latest \
      | grep -o "\"browser_download_url\": \"[^\"]*${FLAVOR}-mauve[^\"]*\"" \
      | grep -o 'https://[^"]*' | head -1)
    if [[ -n "$GTK_URL" ]]; then
      wget -qO /tmp/catppuccin-gtk.zip "$GTK_URL"
      unzip -q /tmp/catppuccin-gtk.zip -d /tmp/catppuccin-gtk
      mkdir -p "$HOME/.local/share/themes"
      cp -r "/tmp/catppuccin-gtk/catppuccin-${FLAVOR}-mauve-standard+default" "$THEME_DIR"
      rm -rf /tmp/catppuccin-gtk.zip /tmp/catppuccin-gtk
      ok "Tema GTK ${FLAVOR^} instalado"
    else
      warn "No se pudo descargar el tema GTK ${FLAVOR^} — instálalo manualmente"
    fi
  else
    ok "Tema GTK ${FLAVOR^} ya instalado"
  fi
}

install_gtk_flavor mocha
install_gtk_flavor latte

THEME_DIR="$HOME/.local/share/themes/catppuccin-mocha-mauve"

log "Aplicando tema GTK3, iconos y cursor..."
gsettings set org.gnome.desktop.interface gtk-theme      'catppuccin-mocha-mauve'
gsettings set org.gnome.desktop.interface icon-theme     'Papirus-Dark'
gsettings set org.gnome.desktop.interface cursor-theme   'Bibata-Modern-Classic'
gsettings set org.gnome.desktop.interface font-name      'JetBrainsMono Nerd Font 11'
ok "GTK3 theme, iconos y cursor aplicados (gsettings)"

# GTK4 ignora gsettings gtk-theme — necesita los archivos en ~/.config/gtk-4.0/
log "Aplicando tema GTK4 (Nautilus, GNOME apps)..."
GTK4_CONFIG="$HOME/.config/gtk-4.0"
mkdir -p "$GTK4_CONFIG"
cp "$THEME_DIR/gtk-4.0/gtk.css"      "$GTK4_CONFIG/gtk.css"
cp "$THEME_DIR/gtk-4.0/gtk-dark.css" "$GTK4_CONFIG/gtk-dark.css"
rm -rf "$GTK4_CONFIG/assets"
cp -r  "$THEME_DIR/gtk-4.0/assets"   "$GTK4_CONFIG/assets"
ok "GTK4 theme aplicado (~/.config/gtk-4.0/)"

# ── Wallpaper ─────────────────────────────────────────────────────────────────
header "Wallpaper"
WALLPAPER_DIR="$HOME/.local/share/wallpapers"
WALLPAPER="$WALLPAPER_DIR/wallpaper.jpg"
mkdir -p "$WALLPAPER_DIR"

if [[ ! -f "$WALLPAPER" && ! -L "$WALLPAPER" ]]; then
  EXISTING=$(find "$WALLPAPER_DIR" -maxdepth 1 \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) ! -name "wallpaper.jpg" 2>/dev/null | head -1)
  if [[ -n "$EXISTING" ]]; then
    ln -sf "$(realpath "$EXISTING")" "$WALLPAPER"
    ok "Wallpaper: enlazado $(basename "$EXISTING") → wallpaper.jpg"
  else
    warn "No se encontró wallpaper — coloca una imagen en $WALLPAPER"
  fi
else
  ok "Wallpaper configurado: $WALLPAPER"
fi

# ── Resumen ───────────────────────────────────────────────────────────────────
echo -e "\n${GREEN}${BOLD}━━━ Instalación completa ━━━${NC}"
echo -e "
  ${BOLD}Próximos pasos:${NC}
  1. Reinicia la sesión para que los cambios de shell tomen efecto
  2. Entra a Hyprland (si no está instalado: bash <script de JaKooLit>)
  3. ${BOLD}SUPER+SHIFT+R${NC} para recargar Hyprland
  4. Abre nautilus para verificar el tema GTK Catppuccin Mocha Mauve

  ${BOLD}Keybinds principales:${NC}
  ALT+Space       → App launcher (wofi)
  SUPER+Return    → Terminal (kitty)
  SUPER+E         → Nautilus
  SUPER+SHIFT+E   → Yazi
  Print           → Screenshot región
  SUPER+A         → EasyEffects
"
