#!/usr/bin/env bash
# Install and link this repository's i3 + Polybar setup on Debian/Ubuntu systems.
# Usage: ./install-i3-polybar-apt.sh [--dry-run]
set -euo pipefail

usage() {
    cat <<'EOF'
Usage: ./install-i3-polybar-apt.sh [--dry-run]

Install the packages used by config/i3 and config/polybar, download the two
Nerd Fonts referenced by the configs, and link i3, Polybar, Rofi, Flameshot,
and Zathura configs into ~/.config. Existing targets are backed up first.
The configured tray requires Polybar 3.7.0 or newer.

Options:
  --dry-run   Show the packages, links, and font downloads without changing anything
  -h, --help  Show this help
EOF
}

dry_run=false
for arg in "$@"; do
    case "$arg" in
        --dry-run) dry_run=true ;;
        -h|--help) usage; exit 0 ;;
        *) printf 'Unknown option: %s\n' "$arg" >&2; usage >&2; exit 2 ;;
    esac
done

if [[ "$(id -u)" -eq 0 ]]; then
    echo "Run this script as your regular user; it calls sudo when needed." >&2
    exit 1
fi

if ! command -v apt-get >/dev/null 2>&1 || ! command -v sudo >/dev/null 2>&1; then
    echo "This installer requires apt-get and sudo." >&2
    exit 1
fi

if [[ ! -r /etc/os-release ]]; then
    echo "Cannot identify this system: /etc/os-release is missing." >&2
    exit 1
fi
# shellcheck disable=SC1091
source /etc/os-release
case " ${ID:-} ${ID_LIKE:-} " in
    *" ubuntu "*|*" debian "*) ;;
    *)
        printf 'Unsupported apt distribution: %s (%s). Supported: Debian/Ubuntu derivatives.\n' \
            "${PRETTY_NAME:-unknown}" "${ID:-unknown}" >&2
        exit 1
        ;;
esac
ubuntu_based=false
case " ${ID:-} ${ID_LIKE:-} " in
    *" ubuntu "*) ubuntu_based=true ;;
esac

repo="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
packages=(
    brightnessctl
    ca-certificates
    curl
    dex
    feh
    fontconfig
    flameshot
    i3-wm
    i3lock
    i3status
    iproute2
    kitty
    network-manager
    network-manager-gnome
    neovim
    picom
    polybar
    psmisc
    pulseaudio-utils
    rofi
    tar
    xss-lock
    xz-utils
    zathura
    zathura-pdf-poppler
)
config_dirs=(i3 polybar rofi flameshot zathura)
fonts=(FiraMono JetBrainsMono)

if "$dry_run"; then
    echo "Distribution: ${PRETTY_NAME:-$ID}"
    echo "Packages: ${packages[*]}"
    echo "Config links:"
    for dir in "${config_dirs[@]}"; do
        printf '  %s -> %s\n' "$repo/config/$dir" "$HOME/.config/$dir"
    done
    printf 'Nerd Fonts: %s\n' "${fonts[*]} (latest release)"
    echo "No changes made."
    exit 0
fi

sudo -v

# Polybar and i3 are in Ubuntu's Universe component.
if "$ubuntu_based"; then
    if ! command -v add-apt-repository >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y software-properties-common
    fi
    sudo add-apt-repository -y universe
fi

echo "Updating apt package lists..."
sudo apt-get update

polybar_candidate="$(apt-cache policy polybar | awk '$1 == "Candidate:" { print $2; exit }')"
if [[ -z "$polybar_candidate" || "$polybar_candidate" == "(none)" ]] ||
    ! dpkg --compare-versions "$polybar_candidate" ge 3.7.0; then
    printf 'The apt repositories offer Polybar %s; this setup requires 3.7.0 or newer.\n' \
        "${polybar_candidate:-none}" >&2
    echo "On Ubuntu, enable Universe or use a newer Debian/Ubuntu release. No configs were linked." >&2
    exit 1
fi

echo "Installing i3, Polybar, and their configured applications..."
sudo apt-get install -y --no-install-recommends "${packages[@]}"

link_config() {
    local source="$1" target="$2" backup
    mkdir -p -- "$(dirname -- "$target")"

    if [[ -L "$target" ]] && [[ "$(readlink -f -- "$target")" == "$(readlink -f -- "$source")" ]]; then
        return
    fi

    if [[ -e "$target" || -L "$target" ]]; then
        backup="${target}.bak-$(date +%Y%m%d%H%M%S)"
        mv -- "$target" "$backup"
        printf 'Backed up existing config: %s\n' "$backup"
    fi

    ln -s -- "$source" "$target"
    printf 'Linked %s -> %s\n' "$target" "$source"
}

echo "Linking application configs..."
for dir in "${config_dirs[@]}"; do
    link_config "$repo/config/$dir" "$HOME/.config/$dir"
done

install_fonts() {
    local font font_dir archive url temp_dir
    font_dir="$HOME/.local/share/fonts"
    temp_dir="$(mktemp -d)"
    mkdir -p -- "$font_dir"

    for font in "${fonts[@]}"; do
        if fc-list : family | grep -Fqi "$font Nerd Font"; then
            printf '%s Nerd Font is already installed.\n' "$font"
            continue
        fi

        archive="$temp_dir/$font.tar.xz"
        url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font.tar.xz"
        echo "Downloading $font Nerd Font..."
        if curl -fL --retry 3 "$url" -o "$archive"; then
            tar -xJf "$archive" -C "$font_dir"
        else
            printf 'Warning: could not download %s Nerd Font.\n' "$font" >&2
        fi
    done

    fc-cache -f "$font_dir"
    rm -f -- "$temp_dir"/*.tar.xz
    rmdir -- "$temp_dir"
}

install_fonts

echo
echo "i3 and Polybar are installed and configured. Select i3 at the login screen."
echo "Polybar chooses desktop/laptop automatically; override with launch.sh desktop or launch.sh laptop."
if [[ ! -e "$HOME/Images/Wallpapers/wall1.png" ]]; then
    echo "Note: add ~/Images/Wallpapers/wall1.png if you want the wallpaper command in the i3 config to find an image."
fi
echo "The i3 Obsidian shortcut requires Obsidian to be installed separately."
