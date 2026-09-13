#!/usr/bin/env bash
# Setup completo de uma maquina Arch + Hyprland a partir deste repositorio.
# Uso: ./install-arch.sh [--dry-run] [--java] [--go] [--rust] [--nix] [--extras]
set -euo pipefail

usage() {
    cat <<'EOF'
Uso: ./install-arch.sh [--dry-run] [--java] [--go] [--rust] [--nix] [--extras]
--dry-run: mostra tudo que seria feito (pacotes, symlinks, servicos) e sai sem alterar nada
--java: JDK 21 e Maven (para o Neovim/jdtls)
--go: Go
--rust: Rust
--nix: nixfmt
--extras: lazygit e Poetry
EOF
}

packages=(
    # Hyprland / Wayland
    hyprland xdg-desktop-portal-hyprland waybar dunst alacritty rofi flameshot
    swaybg hyprpolkitagent brightnessctl playerctl libnotify wl-clip-persist
    pipewire pipewire-pulse wireplumber pavucontrol hyprlock hypridle fzf
    xdg-utils papirus-icon-theme
    # Base / dev tooling
    base-devel make gcc git curl wget unzip tar gzip tree-sitter-cli
    ripgrep python python-pip noto-fonts-emoji github-cli docker
    docker-compose
    # Neovim + formatadores/linters usados pelos plugins
    neovim nodejs npm ruff stylua prettier
    # Shell / CLI usados em config/zsh/.zshrc
    zsh starship
    # Outros apps com config versionada
    zathura zathura-pdf-poppler
)

dry_run=false
for arg in "$@"; do
    case "$arg" in
        --dry-run) dry_run=true ;;
        --java) packages+=(jdk21-openjdk maven) ;;
        --go) packages+=(go) ;;
        --rust) packages+=(rust) ;;
        --nix) packages+=(nixfmt) ;;
        --extras) packages+=(lazygit python-poetry) ;;
        -h|--help) usage; exit 0 ;;
        *) usage >&2; exit 2 ;;
    esac
done

config_dirs=(hypr waybar alacritty rofi dunst flameshot zathura kz nvim)

join_by() {
    local sep="$1"
    shift
    local out="$1"
    shift
    printf '%s' "$out"
    printf "$sep%s" "$@"
}

show_summary() {
    echo "Isto sera instalado/configurado por ./install-arch.sh:"
    echo
    echo "Pacotes (pacman -Syu --needed):"
    echo "  $(join_by ', ' "${packages[@]}")"
    echo
    echo "Symlinks de config (~/.config/<app> -> config/<app> deste repo):"
    echo "  $(join_by ', ' "${config_dirs[@]}"), starship.toml -> ~/.config/starship.toml"
    echo
    echo "Outros passos:"
    echo "  - zsh como shell padrao + plugins zsh-autosuggestions/zsh-syntax-highlighting em ~/.zsh"
    echo "  - fontes GeistMono e JetBrainsMono Nerd Font em ~/.local/share/fonts"
    echo "  - scripts de config/local-bin/ em ~/.local/bin"
    echo "  - servico systemd --user hypridle.service habilitado"
    echo "  - docker.socket habilitado + usuario adicionado ao grupo docker"
    echo "  - wallpapers de assets/wallpapers/ symlinkados em ~/Images/Wallpapers"
    echo "  - pasta ~/Developments/Git"
    echo
}

if "$dry_run"; then
    show_summary
    echo "--dry-run: nada foi alterado."
    exit 0
fi

# Outros passos alem dos pacotes (ver --dry-run para a lista completa):
#   - symlinks de config/{hypr,waybar,alacritty,rofi,dunst,flameshot,zathura,kz,nvim}
#     e config/starship/starship.toml para ~/.config
#   - zsh como shell padrao + plugins zsh-autosuggestions/zsh-syntax-highlighting em ~/.zsh
#   - fontes GeistMono e JetBrainsMono Nerd Font em ~/.local/share/fonts
#   - scripts de config/local-bin/ symlinkados em ~/.local/bin
#   - servico systemd --user hypridle.service habilitado
#   - docker.socket habilitado + usuario adicionado ao grupo docker
#   - wallpapers de assets/wallpapers/ symlinkados em ~/Images/Wallpapers
#   - pasta ~/Developments/Git

repo="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
warnings=()

log() { printf '\n\033[1;34m[+]\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$1" >&2; warnings+=("$1"); }

if [[ "$(id -u)" -eq 0 ]]; then
    echo "Nao rode este script como root. Rode como usuario normal (ele usa sudo quando precisa)." >&2
    exit 1
fi
if ! command -v pacman >/dev/null; then
    echo "Este script e apenas para Arch Linux (pacman nao encontrado)." >&2
    exit 1
fi

# Symlinka source -> target, fazendo backup do que ja existir e nao for o link esperado.
link() {
    local source="$1" target="$2"
    mkdir -p -- "$(dirname -- "$target")"
    if [[ -L "$target" && "$(readlink -f -- "$target")" == "$(readlink -f -- "$source")" ]]; then
        return
    fi
    if [[ -e "$target" || -L "$target" ]]; then
        local backup="${target}.bak-$(date +%Y%m%d%H%M%S)"
        mv -- "$target" "$backup"
        warn "Backup criado: $backup"
    fi
    ln -s -- "$source" "$target"
}

install_packages() {
    log "Atualizando o sistema e instalando pacotes..."
    sudo pacman -Syu --needed --noconfirm "${packages[@]}"
}

setup_shell() {
    log "Configurando zsh..."
    if ! grep -qF "$(command -v zsh)" /etc/shells 2>/dev/null; then
        command -v zsh | sudo tee -a /etc/shells >/dev/null
    fi
    if [[ "${SHELL:-}" != "$(command -v zsh)" ]]; then
        sudo chsh -s "$(command -v zsh)" "$USER"
    fi
    mkdir -p "$HOME/.zsh"
    [[ -d "$HOME/.zsh/zsh-autosuggestions" ]] || \
        git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
    [[ -d "$HOME/.zsh/zsh-syntax-highlighting" ]] || \
        git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.zsh/zsh-syntax-highlighting"
    link "$repo/config/zsh/.zshrc" "$HOME/.zshrc"
}

install_fonts() {
    log "Instalando fontes (GeistMono, JetBrainsMono Nerd Fonts)..."
    local font_dir="$HOME/.local/share/fonts"
    local version="v3.2.1"
    mkdir -p "$font_dir"
    for font in GeistMono JetBrainsMono; do
        if fc-list | grep -qi "$font Nerd Font"; then
            continue
        fi
        local zip="$font_dir/$font.zip"
        local url="https://github.com/ryanoasis/nerd-fonts/releases/download/$version/$font.zip"
        if wget -q --show-progress "$url" -O "$zip"; then
            unzip -qo "$zip" -d "$font_dir"
        else
            warn "Falha ao baixar a fonte $font."
        fi
        rm -f -- "$zip"
    done
    fc-cache -f >/dev/null
}

link_configs() {
    log "Symlinkando configs para ~/.config..."
    for d in "${config_dirs[@]}"; do
        link "$repo/config/$d" "$HOME/.config/$d"
    done
    link "$repo/config/starship/starship.toml" "$HOME/.config/starship.toml"

    log "Symlinkando scripts locais..."
    mkdir -p "$HOME/.local/bin"
    for script in "$repo/config/local-bin/"*; do
        link "$script" "$HOME/.local/bin/$(basename "$script")"
    done

    link "$repo/config/systemd/user/hypridle.service" "$HOME/.config/systemd/user/hypridle.service"
}

setup_wallpapers() {
    log "Configurando wallpapers..."
    mkdir -p "$HOME/Images/Wallpapers"
    shopt -s nullglob
    for wp in "$repo/assets/wallpapers/"*; do
        link "$wp" "$HOME/Images/Wallpapers/$(basename "$wp")"
    done
    shopt -u nullglob
}

# Sem systemd como PID 1 (container, chroot) os passos com systemctl sao pulados.
has_systemd() {
    [[ -d /run/systemd/system ]]
}

setup_docker() {
    log "Configurando Docker..."
    sudo usermod -aG docker "$USER"
    if has_systemd; then
        sudo systemctl enable --now docker.socket
    else
        warn "systemd nao esta rodando; habilite depois: sudo systemctl enable --now docker.socket"
    fi
}

setup_dirs() {
    mkdir -p "$HOME/Developments/Git"
}

setup_services() {
    if ! has_systemd; then
        warn "systemd nao esta rodando; habilite depois: systemctl --user enable --now hypridle.service"
        return
    fi
    log "Habilitando servicos de usuario..."
    systemctl --user daemon-reload
    systemctl --user enable --now hypridle.service
}

install_packages
setup_shell
install_fonts
link_configs
setup_wallpapers
setup_docker
setup_dirs
setup_services

echo
echo "Setup concluido."
if [[ ${#warnings[@]} -gt 0 ]]; then
    echo "Avisos:"
    printf ' - %s\n' "${warnings[@]}"
fi
echo
if [[ ! -e "$repo/config/hypr/local.lua" ]]; then
    echo "Monitor, teclado e wallpaper desta maquina: cp $repo/config/hypr/local.lua.example $repo/config/hypr/local.lua"
fi
echo "Para novos wallpapers: coloque imagens em $repo/assets/wallpapers/ e rode este script de novo."
echo

read -rp "Deseja reiniciar agora? [y/N]: " answer || answer=""
answer=${answer,,}
if [[ "$answer" == y* ]]; then
    sudo reboot
else
    echo "Reinicie manualmente quando for conveniente."
fi
