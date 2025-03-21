#!/usr/bin/sh

set -e

DOTFILES_REPO="https://github.com/luwired/dotfiles.git"

echo ">>> 📦 Updating pkg..."
sudo pkg update
sudo pkg upgrade -y

echo ">>> 📚 Installing basic packages..."
sudo pkg install -y \
    7-zip alsa-utils neovim tree-sitter-cli unzip \
    wget curl zsh git kitty

echo ">>> 🐚 Changing default shell to Zsh..."
chsh -s /usr/local/bin/zsh

echo ">>> 🔧 Cloning and applying dotfiles..."
if [ ! -d "$HOME/.dotfiles" ]; then
    git clone "$DOTFILES_REPO" "$HOME/.dotfiles"
    echo ">>> 📂 Creating .config directory if necessary..."
    mkdir -p "$HOME/.config"
    echo ">>> 📂 Moving configuration files..."
    sudo mv "$HOME/.dotfiles/config/kitty" "$HOME/.config/"
    sudo mv "$HOME/.dotfiles/config/nvim" "$HOME/.config/"
fi

echo ">>> ✅ Installation complete! Please restart your system to apply all configurations."
