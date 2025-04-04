#!/bin/bash

set -e

DOTFILES_REPO="https://github.com/luwired/dotfiles.git"
PACKAGES=(
    alsa-utils
    haruna
    kitty
    neovim
    tree-sitter-cli
    unzip
    polybar
    feh
    wget
    curl
    rofi
    ufw
    zsh
    base-devel
)
CONFIG_DIRS=(
    i3
    kitty
    nvim
    polybar
    rofi
)
FONT_DIR="$HOME/.local/share/fonts"
NERD_FONTS_VERSION="v3.3.0"
GEIST_MONO_ZIP="GeistMono.zip"
JETBRAINS_MONO_ZIP="JetBrainsMono.zip"

echo ">>> 🔄 Updating system packages..."
sudo pacman -Syyu --noconfirm

echo ">>> 📚 Installing basic packages..."
sudo pacman -S --noconfirm --needed "${PACKAGES[@]}"

echo ">>> 🐚 Changing default shell to Zsh..."
if ! grep -q "$(which zsh)" /etc/shells; then
    echo "$(which zsh)" | sudo tee -a /etc/shells
fi
chsh -s "$(which zsh)"

echo ">>> 📥 Cloning dotfiles repository..."
git clone --depth=1 "$DOTFILES_REPO" "$HOME/dotfiles"

echo ">>> 📂 Moving configuration files..."
for config_dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$HOME/.config/$config_dir" ]; then
        echo "    🗑️ Removing existing $HOME/.config/$config_dir"
        sudo rm -rf "$HOME/.config/$config_dir"
    fi
    echo "    ➡️ Moving $HOME/dotfiles/config/$config_dir to $HOME/.config/"
    mkdir -p "$HOME/.config"
    sudo mv "$HOME/dotfiles/config/$config_dir" "$HOME/.config/"
done
mkdir -p "$HOME/Images/Wallpapers"

echo ">>> 🐍 Configuring pyenv..."
if ! [ -d "$HOME/.pyenv" ]; then
    git clone "https://github.com/pyenv/pyenv.git" "$HOME/.pyenv"
    cd "$HOME/.pyenv" && src/configure && make -C src
fi

ZSHRC="$HOME/.zshrc"
if ! grep -q "pyenv init" "$ZSHRC"; then
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> "$ZSHRC"
    echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> "$ZSHRC"
    echo 'eval "$(pyenv init - zsh)"' >> "$ZSHRC"
    echo ">>> ⚙️ Added pyenv configuration to $ZSHRC. Please open a new terminal or run 'source $ZSHRC'."
else
    echo ">>> ✅ pyenv configuration already exists in $ZSHRC."
fi

echo ">>> 🎨 Installing Nerd Fonts..."
mkdir -p "$FONT_DIR"

download_and_install_font() {
    local font_name="$1"
    local zip_file="$FONT_DIR/$font_name.zip"
    local github_url="https://github.com/ryanoasis/nerd-fonts/releases/download/$NERD_FONTS_VERSION/$font_name.zip"

    if [ ! -f "$zip_file" ]; then
        echo "    ⬇️ Downloading $font_name..."
        wget "$github_url" -O "$zip_file"
        if [ $? -eq 0 ]; then
            echo "    📦 Unzipping $font_name..."
            unzip -o "$zip_file" -d "$FONT_DIR"
            rm "$zip_file"
            echo "    ✅ $font_name installed."
        else
            echo "    ❌ Failed to download $font_name."
        fi
    else
        echo "    ✅ $font_name already downloaded."
        unzip -o "$zip_file" -d "$FONT_DIR"
        rm "$zip_file"
        echo "    ✅ $font_name installed."
    fi
}

download_and_install_font "$GEIST_MONO_ZIP"
download_and_install_font "$JETBRAINS_MONO_ZIP"

echo ">>> 🧹 Cleaning up font archives..."
find "$FONT_DIR" -name "*.zip" -delete

echo ">>> 🚀 Installation complete! Please restart your system and ensure your terminal and applications are configured to use the installed fonts."
