#!/usr/bin/env bash
# Complete setup of an Arch + Hyprland machine from this repository.
# Usage: ./install-arch.sh [--dry-run] [--java] [--go] [--rust] [--nix] [--extras]
set -euo pipefail

usage() {
    cat <<'EOF'
Usage: ./install-arch.sh [--dry-run] [--java] [--go] [--rust] [--nix] [--extras]
--dry-run: show planned packages, symlinks and services, then exit without making changes
--java: JDK 21 and Maven (for Neovim/jdtls)
--go: Go
--rust: Rust
--nix: nixfmt
--extras: lazygit and Poetry
EOF
}

packages=(
    # Hyprland / Wayland
    hyprland xdg-desktop-portal-hyprland waybar dunst alacritty rofi flameshot
    hyprpaper hyprpolkitagent brightnessctl playerctl libnotify wl-clip-persist
    pipewire pipewire-pulse wireplumber pavucontrol hyprlock hypridle fzf
    xdg-utils papirus-icon-theme networkmanager
    # File manager
    thunar gvfs tumbler thunar-volman xarchiver dconf gsettings-desktop-schemas
    # Base / dev tooling
    base-devel make gcc git curl wget unzip tar gzip tree-sitter-cli sqlite
    ripgrep python python-pip noto-fonts-emoji ttf-liberation adwaita-fonts github-cli docker
    docker-compose
    # Neovim + formatters/linters used by the plugins
    neovim nodejs npm ruff stylua prettier
    # Shell / CLI tools used in config/zsh/.zshrc
    zsh starship
    # Other apps with version-controlled configuration
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

config_dirs=(hypr waybar alacritty rofi dunst flameshot zathura kz nvim fontconfig gtk-3.0 gtk-4.0)

join_by() {
    local sep="$1"
    shift
    local out="$1"
    shift
    printf '%s' "$out"
    printf "$sep%s" "$@"
}

show_summary() {
    echo "./install-arch.sh will install/configure the following:"
    echo
    echo "Packages (pacman -Syu --needed):"
    echo "  $(join_by ', ' "${packages[@]}")"
    echo
    echo "Configuration symlinks (~/.config/<app> -> config/<app> in this repo):"
    echo "  $(join_by ', ' "${config_dirs[@]}"), starship.toml -> ~/.config/starship.toml"
    echo
    echo "Additional steps:"
    echo "  - zsh as the default shell + zsh-autosuggestions/zsh-syntax-highlighting plugins in ~/.zsh"
    echo "  - GeistMono, JetBrainsMono and FiraCode Nerd Fonts in ~/.local/share/fonts"
    echo "  - scripts from config/local-bin/ in ~/.local/bin"
    echo "  - NetworkManager and hypridle.service enabled"
    echo "  - docker.socket enabled + user added to the docker group"
    echo "  - wallpapers from assets/wallpapers/ symlinked into ~/Images/Wallpapers"
    echo "  - ~/Developments/Git directory"
    echo "  - GTK dark theme (Adwaita + Papirus-Dark) via gsettings"
    echo
}

if "$dry_run"; then
    show_summary
    echo "--dry-run: no changes made."
    exit 0
fi

# Additional steps beyond packages (see --dry-run for the full list):
#   - symlinks from config/{hypr,waybar,alacritty,rofi,dunst,flameshot,zathura,kz,nvim,fontconfig,gtk-3.0,gtk-4.0}
#     and config/starship/starship.toml to ~/.config
#   - zsh as the default shell + zsh-autosuggestions/zsh-syntax-highlighting plugins in ~/.zsh
#   - GeistMono, JetBrainsMono and FiraCode Nerd Fonts in ~/.local/share/fonts
#   - scripts from config/local-bin/ symlinked into ~/.local/bin
#   - NetworkManager and hypridle.service enabled
#   - docker.socket enabled + user added to the docker group
#   - wallpapers from assets/wallpapers/ symlinked into ~/Images/Wallpapers
#   - ~/Developments/Git directory
#   - GTK dark theme (Adwaita + Papirus-Dark) via gsettings

repo="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
warnings=()

log() { printf '\n\033[1;34m[+]\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$1" >&2; warnings+=("$1"); }

if [[ "$(id -u)" -eq 0 ]]; then
    echo "Do not run this script as root. Run as a regular user (it uses sudo when needed)." >&2
    exit 1
fi
if ! command -v pacman >/dev/null; then
    echo "This script is for Arch Linux only (pacman not found)." >&2
    exit 1
fi

# Symlink source -> target, backing up any existing target that is not the expected link.
link() {
    local source="$1" target="$2"
    mkdir -p -- "$(dirname -- "$target")"
    if [[ -L "$target" && "$(readlink -f -- "$target")" == "$(readlink -f -- "$source")" ]]; then
        return
    fi
    if [[ -e "$target" || -L "$target" ]]; then
        local backup="${target}.bak-$(date +%Y%m%d%H%M%S)"
        mv -- "$target" "$backup"
        warn "Backup created: $backup"
    fi
    ln -s -- "$source" "$target"
}

install_packages() {
    log "Updating the system and installing packages..."
    sudo pacman -Syu --needed --noconfirm "${packages[@]}"
}

setup_shell() {
    log "Configuring zsh..."
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
    log "Installing fonts (GeistMono, JetBrainsMono, FiraCode Nerd Fonts)..."
    local font_dir="$HOME/.local/share/fonts"
    local version="v3.2.1"
    mkdir -p "$font_dir"
    for font in GeistMono JetBrainsMono FiraCode; do
        if fc-list | grep -qi "$font Nerd Font"; then
            continue
        fi
        local zip="$font_dir/$font.zip"
        local url="https://github.com/ryanoasis/nerd-fonts/releases/download/$version/$font.zip"
        if wget -q --show-progress "$url" -O "$zip"; then
            unzip -qo "$zip" -d "$font_dir"
        else
            warn "Failed to download the $font font."
        fi
        rm -f -- "$zip"
    done
    fc-cache -f >/dev/null
}

link_configs() {
    log "Symlinking configurations into ~/.config..."
    for d in "${config_dirs[@]}"; do
        link "$repo/config/$d" "$HOME/.config/$d"
    done
    link "$repo/config/starship/starship.toml" "$HOME/.config/starship.toml"

    log "Symlinking local scripts..."
    mkdir -p "$HOME/.local/bin"
    for script in "$repo/config/local-bin/"*; do
        link "$script" "$HOME/.local/bin/$(basename "$script")"
    done

    link "$repo/config/systemd/user/hypridle.service" "$HOME/.config/systemd/user/hypridle.service"
}

setup_wallpapers() {
    log "Configuring wallpapers..."
    mkdir -p "$HOME/Images/Wallpapers"
    shopt -s nullglob
    for wp in "$repo/assets/wallpapers/"*; do
        link "$wp" "$HOME/Images/Wallpapers/$(basename "$wp")"
    done
    shopt -u nullglob
}

# Without systemd as PID 1 (container, chroot), skip systemctl steps.
has_systemd() {
    [[ -d /run/systemd/system ]]
}

setup_docker() {
    log "Configuring Docker..."
    sudo usermod -aG docker "$USER"
    if has_systemd; then
        sudo systemctl enable --now docker.socket
    else
        warn "systemd is not running; enable later: sudo systemctl enable --now docker.socket"
    fi
}

setup_dirs() {
    mkdir -p "$HOME/Developments/Git"
}

setup_gtk_theme() {
    log "Applying the GTK dark theme (Adwaita + Papirus-Dark)..."
    command -v gsettings >/dev/null || return
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
}

setup_services() {
    if ! has_systemd; then
        warn "systemd is not running; enable later: sudo systemctl enable --now NetworkManager and systemctl --user enable --now hypridle.service"
        return
    fi
    log "Enabling services..."
    sudo systemctl enable --now NetworkManager
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
setup_gtk_theme
setup_services

echo
echo "Setup complete."
if [[ ${#warnings[@]} -gt 0 ]]; then
    echo "Warnings:"
    printf ' - %s\n' "${warnings[@]}"
fi
echo
if [[ ! -e "$repo/config/hypr/local.lua" ]]; then
    echo "Monitor, keyboard and wallpaper for this machine: cp $repo/config/hypr/local.lua.example $repo/config/hypr/local.lua"
fi
echo "For new wallpapers: place images in $repo/assets/wallpapers/ and run this script again."
echo

read -rp "Reboot now? [y/N]: " answer || answer=""
answer=${answer,,}
if [[ "$answer" == y* ]]; then
    sudo reboot
else
    echo "Reboot manually when convenient."
fi
