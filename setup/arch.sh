#!/bin/bash

set -e

DOTFILES_REPO="https://github.com/luwired/dotfiles.git"
PACKAGES=(
    alsa-utils
    haruna
    obsidian
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
NODEJS_VERSION="v22.14.0"
NODEJS_ARCH="linux-x64"
NODEJS_FILENAME="node-$NODEJS_VERSION-$NODEJS_ARCH.tar.xz"
NODEJS_URL="https://nodejs.org/dist/$NODEJS_VERSION/$NODEJS_FILENAME"
NODEJS_INSTALL_DIR="$HOME/.local/opt/nodejs"
ZEN_BROWSER_FILENAME="zen.linux-x86_64.tar.xz"
ZEN_BROWSER_URL="https://github.com/zen-browser/desktop/releases/latest/download/$ZEN_BROWSER_FILENAME"
ZEN_BROWSER_INSTALL_DIR="$HOME/.local/opt/zen-browser"
ZEN_BROWSER_BIN_DIR="$ZEN_BROWSER_INSTALL_DIR/app"

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

echo ">>> ⚛️ Installing Node.js $NODEJS_VERSION..."
mkdir -p "$NODEJS_INSTALL_DIR"
if [ ! -d "$NODEJS_INSTALL_DIR/bin/node" ]; then
    echo "    ⬇️ Downloading Node.js..."
    wget "$NODEJS_URL" -P /tmp
    if [ $? -eq 0 ]; then
        echo "    📦 Extracting Node.js..."
        tar -xJf "/tmp/$NODEJS_FILENAME" -C "$NODEJS_INSTALL_DIR" --strip-components=1
        if [ $? -eq 0 ]; then
            echo "    ✅ Node.js installed in $NODEJS_INSTALL_DIR."
            # Add Node.js to PATH in .zshrc
            if ! grep -q "export PATH=\"\$HOME/.local/opt/nodejs/bin:\$PATH\"" "$ZSHRC"; then
                echo 'export PATH="$HOME/.local/opt/nodejs/bin:$PATH"' >> "$ZSHRC"
                echo ">>> ⚙️ Added Node.js to PATH in $ZSHRC. Please open a new terminal or run 'source $ZSHRC'."
            else
                echo ">>> ✅ Node.js PATH already configured in $ZSHRC."
            fi
            rm "/tmp/$NODEJS_FILENAME"
        else
            echo "    ❌ Failed to extract Node.js."
        fi
    else
        echo "    ❌ Failed to download Node.js."
    fi
else
    echo ">>> ✅ Node.js already installed."
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

echo ">>> 🦊 Installing Zen Browser..."
mkdir -p "$ZEN_BROWSER_INSTALL_DIR"
if [ ! -f "$ZEN_BROWSER_BIN_DIR/zen" ]; then
    echo "    ⬇️ Downloading Zen Browser..."
    wget "$ZEN_BROWSER_URL" -O "/tmp/$ZEN_BROWSER_FILENAME"
    if [ $? -eq 0 ]; then
        echo "    📦 Extracting Zen Browser..."
        tar -xJf "/tmp/$ZEN_BROWSER_FILENAME" -C "$ZEN_BROWSER_INSTALL_DIR" --strip-components=1
        if [ $? -eq 0 ]; then
            echo "    ✅ Zen Browser installed in $ZEN_BROWSER_INSTALL_DIR."
            # Create a symbolic link for easier access
            if [ ! -f "$HOME/.local/bin/zen" ]; then
                mkdir -p "$HOME/.local/bin"
                ln -s "$ZEN_BROWSER_BIN_DIR/zen" "$HOME/.local/bin/zen"
                echo "    🔗 Created symbolic link for Zen Browser in $HOME/.local/bin. Ensure $HOME/.local/bin is in your PATH."
            else
                echo "    🔗 Symbolic link for Zen Browser already exists."
            fi
            rm "/tmp/$ZEN_BROWSER_FILENAME"
        else
            echo "    ❌ Failed to extract Zen Browser."
        fi
    else
        echo "    ❌ Failed to download Zen Browser."
    fi
else
    echo ">>> ✅ Zen Browser already installed."
fi

echo ">>> 🧹 Cleaning up font archives..."
find "$FONT_DIR" -name "*.zip" -delete

echo ">>> 🚀 Installation complete! Please restart your system and ensure your terminal and applications are configured to use the installed fonts."
