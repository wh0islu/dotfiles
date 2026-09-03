#!/usr/bin/env bash
set -euo pipefail  # Handles pipeline errors, undefined variables, and other failures.

# ====================== Configuration ======================
DOTFILES_REPO_DIR="$HOME/Downloads/dotfiles-main"
ZSHRC="$HOME/.zshrc"

CONFIG_DIRS=(
    i3
    kitty
    polybar
    rofi
)

PACKAGES=(
    kitty
    tree-sitter-cli
    unzip
    polybar
    xclip
    curl
    rofi
    python
    papirus-icon-theme
    noto-fonts-emoji
    github-cli
    flameshot
    zsh
    base-devel
    make
    docker
    docker-compose  # optional, but useful
)

FONT_DIR="$HOME/.local/share/fonts"
NERD_FONTS_VERSION="v3.2.1"  # Selected compatible release.
FONTS_TO_INSTALL=("GeistMono" "JetBrainsMono")

NODE_VERSION="22.13.1"  # Stable LTS release for this setup script.
NODE_ARCH="linux-x64"
NODE_FILENAME="node-v$NODE_VERSION-$NODE_ARCH.tar.xz"
NODE_URL="https://nodejs.org/dist/v$NODE_VERSION/$NODE_FILENAME"
NODE_INSTALL_DIR="$HOME/.local/opt/nodejs"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.zsh/custom}"  # Honor the standard Oh My Zsh variable when set.

# ====================== Helper functions ======================
log() {
    echo "[+] $1"
}

error() {
    echo "[!] $1" >&2
}

# ====================== Script start ======================
log "Updating the system..."
sudo pacman -Syyu --noconfirm

log "Installing essential packages..."
sudo pacman -S --noconfirm --needed "${PACKAGES[@]}"

log "Configuring Docker..."
sudo systemctl enable --now docker.socket  # Lighter than enabling the full Docker service.
sudo usermod -aG docker "$USER"
newgrp docker << EOF || true  # Try to apply the group without logging out; failure is non-critical.
EOF

log "Setting Zsh as the default shell..."
if ! grep -q "$(which zsh)" /etc/shells; then
    which zsh | sudo tee -a /etc/shells >/dev/null
fi
chsh -s "$(which zsh)" "$USER"

log "Configuring dotfiles..."
for dir in "${CONFIG_DIRS[@]}"; do
    target="$HOME/.config/$dir"
    source_dir="$DOTFILES_REPO_DIR/config/$dir"

    [[ -d "$target" ]] && rm -rf "$target"  # User-owned directory; sudo is not required.
    mkdir -p "$HOME/.config"
    mv "$source_dir" "$target"
done

mkdir -p "$HOME/Images/Wallpapers" "$HOME/Developments/Git"
mv "$DOTFILES_REPO_DIR/config/zsh/.zshrc" "$ZSHRC"

log "Installing Zsh plugins..."
mkdir -p "$ZSH_CUSTOM/plugins"
git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

log "Installing Node.js $NODE_VERSION..."
mkdir -p "$NODE_INSTALL_DIR"
if [[ ! -x "$NODE_INSTALL_DIR/bin/node" ]]; then
    tmp_file="/tmp/$NODE_FILENAME"
    wget -q "$NODE_URL" -O "$tmp_file"
    tar -xJf "$tmp_file" -C "$NODE_INSTALL_DIR" --strip-components=1
    rm "$tmp_file"

    # Add it to PATH only when it is not already present.
    grep -qF "$NODE_INSTALL_DIR/bin" "$ZSHRC" || echo "export PATH=\"$NODE_INSTALL_DIR/bin:\$PATH\"" >> "$ZSHRC"
fi

log "Installing Nerd Fonts..."
mkdir -p "$FONT_DIR"
for font in "${FONTS_TO_INSTALL[@]}"; do
    zip_file="$FONT_DIR/$font.zip"
    url="https://github.com/ryanoasis/nerd-fonts/releases/download/$NERD_FONTS_VERSION/$font.zip"

    wget -q --show-progress "$url" -O "$zip_file"
    unzip -qo "$zip_file" -d "$FONT_DIR"
    rm "$zip_file"
done

# Update the font cache.
fc-cache -fv >/dev/null

log "Final cleanup..."
find "$FONT_DIR" -name "*.zip" -delete 2>/dev/null || true

log "Setup completed successfully!"

read -rp "Do you want to restart the system now? [y/N]: " answer
answer=${answer,,}
if [[ "$answer" == y* || "$answer" == "yes" ]]; then
    log "Restarting..."
    sudo reboot
else
    log "Restart canceled. Restart manually when convenient."
fi
