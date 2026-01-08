#!/usr/bin/env bash
set -euo pipefail  # Melhor que só set -e: trata erros em pipelines, variáveis não definidas, etc.

# ====================== Configurações ======================
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
    docker-compose  # opcional, mas útil
)

FONT_DIR="$HOME/.local/share/fonts"
NERD_FONTS_VERSION="v3.2.1"  # Atualizada (v3.4.0 não existe ainda em jan/2026, última é ~v3.2)
FONTS_TO_INSTALL=("GeistMono" "JetBrainsMono")

NODE_VERSION="22.13.1"  # LTS mais recente e estável (evite versões muito novas em scripts)
NODE_ARCH="linux-x64"
NODE_FILENAME="node-v$NODE_VERSION-$NODE_ARCH.tar.xz"
NODE_URL="https://nodejs.org/dist/v$NODE_VERSION/$NODE_FILENAME"
NODE_INSTALL_DIR="$HOME/.local/opt/nodejs"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.zsh/custom}"  # Respeita variável padrão do Oh My Zsh se existir

# ====================== Funções auxiliares ======================
log() {
    echo "[+] $1"
}

error() {
    echo "[!] $1" >&2
}

# ====================== Início do script ======================
log "Atualizando o sistema..."
sudo pacman -Syyu --noconfirm

log "Instalando pacotes essenciais..."
sudo pacman -S --noconfirm --needed "${PACKAGES[@]}"

log "Configurando Docker..."
sudo systemctl enable --now docker.socket  # Mais leve que enable --now docker
sudo usermod -aG docker "$USER"
newgrp docker << EOF || true  # Tenta aplicar grupo sem logout (não crítico se falhar)
EOF

log "Configurando Zsh como shell padrão..."
if ! grep -q "$(which zsh)" /etc/shells; then
    which zsh | sudo tee -a /etc/shells >/dev/null
fi
chsh -s "$(which zsh)" "$USER"

log "Configurando dotfiles..."
for dir in "${CONFIG_DIRS[@]}"; do
    target="$HOME/.config/$dir"
    source_dir="$DOTFILES_REPO_DIR/config/$dir"

    [[ -d "$target" ]] && rm -rf "$target"  # Remove sem sudo (é do usuário)
    mkdir -p "$HOME/.config"
    mv "$source_dir" "$target"
done

mkdir -p "$HOME/Images/Wallpapers" "$HOME/Developments/Git"
mv "$DOTFILES_REPO_DIR/config/zsh/.zshrc" "$ZSHRC"

log "Instalando plugins do Zsh..."
mkdir -p "$ZSH_CUSTOM/plugins"
git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

log "Instalando Node.js $NODE_VERSION..."
mkdir -p "$NODE_INSTALL_DIR"
if [[ ! -x "$NODE_INSTALL_DIR/bin/node" ]]; then
    tmp_file="/tmp/$NODE_FILENAME"
    wget -q "$NODE_URL" -O "$tmp_file"
    tar -xJf "$tmp_file" -C "$NODE_INSTALL_DIR" --strip-components=1
    rm "$tmp_file"

    # Adiciona ao PATH só se não existir
    grep -qF "$NODE_INSTALL_DIR/bin" "$ZSHRC" || echo "export PATH=\"$NODE_INSTALL_DIR/bin:\$PATH\"" >> "$ZSHRC"
fi

log "Instalando Nerd Fonts..."
mkdir -p "$FONT_DIR"
for font in "${FONTS_TO_INSTALL[@]}"; do
    zip_file="$FONT_DIR/$font.zip"
    url="https://github.com/ryanoasis/nerd-fonts/releases/download/$NERD_FONTS_VERSION/$font.zip"

    wget -q --show-progress "$url" -O "$zip_file"
    unzip -qo "$zip_file" -d "$FONT_DIR"
    rm "$zip_file"
done

# Atualiza cache de fontes
fc-cache -fv >/dev/null

log "Limpeza final..."
find "$FONT_DIR" -name "*.zip" -delete 2>/dev/null || true

log "Setup concluído com sucesso!"

read -rp "Deseja reiniciar o sistema agora? [y/N]: " answer
answer=${answer,,}
if [[ "$answer" == y* || "$answer" == "yes" ]]; then
    log "Reiniciando..."
    sudo reboot
else
    log "Reboot cancelado. Reinicie manualmente quando conveniente."
fi
