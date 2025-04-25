#!/bin/bash
set -e

DOTFILES_REPO_DIR="$HOME/dotfiles"
ZSHRC="$HOME/.zshrc"
CONFIG_DIRS=(
    i3
    kitty
    nvim
    polybar
    rofi
)

PACKAGES=(
    alsa-utils
    obsidian
    kitty
    neovim
    tree-sitter-cli
    unzip
    polybar
    feh
    xclip
    mandoc
    plocate
    wget
    curl
    rofi
    python
    python-pip
    python-pipx
    python-pynvim
    papirus-icon-theme
    noto-fonts-emoji
    thunar
    picom
    flameshot
    lua
    luarocks
    ufw
    zsh
    base-devel
    make
    docker
)

FONT_DIR="$HOME/.local/share/fonts"
NERD_FONTS_VERSION="v3.3.0"
FONTS_TO_INSTALL=("GeistMono" "JetBrainsMono")

NODE_VERSION="v22.14.0"
NODE_ARCH="linux-x64"
NODE_FILENAME="node-$NODE_VERSION-$NODE_ARCH.tar.xz"
NODE_URL="https://nodejs.org/dist/$NODE_VERSION/$NODE_FILENAME"
NODE_INSTALL_DIR="$HOME/.local/opt/nodejs"

ZEN_FILENAME="zen.linux-x86_64.tar.xz"
ZEN_URL="https://github.com/zen-browser/desktop/releases/latest/download/$ZEN_FILENAME"
ZEN_TMP="/tmp/$ZEN_FILENAME"
ZEN_DIR="/opt/zen"
ZEN_BIN="$ZEN_DIR/zen"

ZSH_CUSTOM="$HOME/.zsh"

echo "Updating system..."
sudo pacman -Syyu --noconfirm

echo "Installing packages..."
sudo pacman -S --noconfirm --needed "${PACKAGES[@]}"

echo "Setup Docker"
sudo systemctl enable --now docker
sudo usermod -aG docker $USER

echo "Setting Zsh as default shell..."
if ! grep -q "$(which zsh)" /etc/shells; then
    echo "$(which zsh)" | sudo tee -a /etc/shells
fi
chsh -s "$(which zsh)"

echo "Setting up configuration files..."
for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$HOME/.config/$dir" ]; then
        sudo rm -rf "$HOME/.config/$dir"
    fi
    mkdir -p "$HOME/.config"
    sudo mv "$DOTFILES_REPO_DIR/config/$dir" "$HOME/.config/"
done

mkdir -p "$HOME/Images/Wallpapers"
mkdir -p "$HOME/Developments/Git"

curl -sS https://starship.rs/install.sh | sh
mkdir -p "$HOME/.config"
mv "$DOTFILES_REPO_DIR/config/starship/starship.toml" "$HOME/.config/"
mv "$DOTFILES_REPO_DIR/config/picom" "$HOME/.config/"

mv "$DOTFILES_REPO_DIR/config/zsh/.zshrc" "$ZSHRC"

echo "Installing zsh plugins..."
mkdir -p "$ZSH_CUSTOM"
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/zsh-syntax-highlighting"

if [ ! -d "$HOME/.pyenv" ]; then
    git clone https://github.com/pyenv/pyenv.git "$HOME/.pyenv"
    cd "$HOME/.pyenv" && src/configure && make -C src
fi

echo "Installing Node.js $NODE_VERSION..."
mkdir -p "$NODE_INSTALL_DIR"
if [ ! -x "$NODE_INSTALL_DIR/bin/node" ]; then
    wget "$NODE_URL" -O "/tmp/$NODE_FILENAME"
    tar -xJf "/tmp/$NODE_FILENAME" -C "$NODE_INSTALL_DIR" --strip-components=1
    rm "/tmp/$NODE_FILENAME"
    if ! grep -q "$NODE_INSTALL_DIR/bin" "$ZSHRC"; then
        echo "export PATH=\"$NODE_INSTALL_DIR/bin:\$PATH\"" >> "$ZSHRC"
    fi
fi

echo "Installing Nerd Fonts..."
mkdir -p "$FONT_DIR"

for font in "${FONTS_TO_INSTALL[@]}"; do
    ZIP_PATH="$FONT_DIR/$font.zip"
    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/$NERD_FONTS_VERSION/$font.zip"
    wget -q "$FONT_URL" -O "$ZIP_PATH"
    unzip -o "$ZIP_PATH" -d "$FONT_DIR"
    rm "$ZIP_PATH"
done

if [ ! -f "$ZEN_BIN" ]; then
    echo "Installing Zen Browser..."
    wget "$ZEN_URL" -O "$ZEN_TMP"
    sudo mkdir -p "$ZEN_DIR"
    sudo tar -xJf "$ZEN_TMP" -C "$ZEN_DIR" --strip-components=1
    rm "$ZEN_TMP"

    if [ -f "$ZEN_DIR/zen-browser" ]; then
        sudo mv "$ZEN_DIR/zen-browser" "$ZEN_BIN"
    fi

    mkdir -p "$HOME/.local/bin"
    ln -sf "$ZEN_BIN" "$HOME/.local/bin/zen"

    if [ -f "$DOTFILES_REPO_DIR/config/desktops/zen.desktop" ]; then
        sudo mv "$DOTFILES_REPO_DIR/config/desktops/zen.desktop" /usr/share/applications/
    fi
fi

echo "Cleaning up..."
find "$FONT_DIR" -name "*.zip" -delete

echo "Setup complete. You may want to restart your system or run 'source ~/.zshrc'."
read -rp "Would you like to reboot the system now? [y/N]: " REBOOT_ANSWER
REBOOT_ANSWER=${REBOOT_ANSWER,,}
if [[ "$REBOOT_ANSWER" == "y" || "$REBOOT_ANSWER" == "yes" ]]; then
    echo "Rebooting the system..."
    sudo reboot
else
    echo "Reboot cancelled. You can manually reboot later using 'sudo reboot'."
fi
