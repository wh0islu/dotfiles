#!/bin/bash

set -e

DOTFILES_REPO="https://github.com/luwired/dotfiles.git"

echo ">>> 🏴 Installing Reflector to optimize mirrors..."
sudo pacman -Sy --noconfirm --needed reflector

echo ">>> 🌎 Updating mirror list to Brazil..."
sudo reflector --country Brazil --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

echo ">>> 📦 Updating pacman and enabling parallel downloads..."
sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
sudo pacman -Sy --noconfirm

echo ">>> 📚 Installing basic packages..."
sudo pacman -S --noconfirm --needed \
  7zip alsa-utils haruna neovim tree-sitter-cli unzip \
  waybar wget curl wofi zsh reflector

echo ">>> 🔽 Installing yay (for AUR packages)..."
if ! command -v yay &> /dev/null; then
  sudo pacman -S --noconfirm --needed git base-devel
  rm -rf /tmp/yay
  git clone https://aur.archlinux.org/yay-bin.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd ~
  rm -rf /tmp/yay
fi

echo ">>> 🐚 Changing default shell to Zsh..."
chsh -s /bin/zsh

echo ">>> 🔧 Cloning and applying dotfiles..."
if [ ! -d "$HOME/.dotfiles" ]; then
  git clone "$DOTFILES_REPO" "$HOME/.dotfiles"
  echo ">>> 📂 Creating .config directory if necessary..."
  echo ">>> 📂 Moving configuration files..."
  sudo mv "$HOME/.dotfiles/config/kitty" "$HOME/.config/"
  sudo mv "$HOME/.dotfiles/config/nvim" "$HOME/.config/"
fi

echo ">>> ✅ Installation complete! Please restart your system to apply all configurations."
