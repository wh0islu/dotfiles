#!/bin/bash

set -e

DOTFILES_REPO="https://github.com/luwired/dotfiles.git"

sudo pacman -Syyu

echo ">>> 📚 Installing basic packages..."
sudo pacman -S --noconfirm --needed \
  7zip alsa-utils haruna kitty neovim tree-sitter-cli unzip \
  polybar wget curl rofi zsh

echo ">>> 🐚 Changing default shell to Zsh..."
chsh -s /bin/zsh

echo ">>> 🔧 Cloning and applying dotfiles..."
if [ ! -d "$HOME/.dotfiles" ]; then
  git clone "$DOTFILES_REPO" "$HOME/dotfiles"
  echo ">>> 📂 Creating .config directory if necessary..."
  echo ">>> 📂 Moving configuration files..."
  sudo mv "$HOME/dotfiles/config/i3" "$HOME/.config/"
  sudo mv "$HOME/dotfiles/config/kitty" "$HOME/.config/"
  sudo mv "$HOME/dotfiles/config/nvim" "$HOME/.config/"
  sudo mv "$HOME/dotfiles/config/polybar" "$HOME/.config/"
  sudo mv "$HOME/dotfiles/config/rofi" "$HOME/.config/"
fi

echo ">>> ✅ Installation complete! Please restart your system to apply all configurations."
