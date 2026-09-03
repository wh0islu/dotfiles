#!/usr/bin/env bash
set -euo pipefail

repo="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

sudo pacman -S --needed \
  hyprland waybar dunst alacritty rofi flameshot grim slurp \
  wl-clipboard cliphist swaybg swaylock hyprpolkitagent \
  brightnessctl playerctl pipewire pipewire-pulse wireplumber pavucontrol \
  hyprlock hypridle qt5ct qt6ct nwg-look papirus-icon-theme \
  fzf fd bat jq yazi zoxide eza xdg-utils

mkdir -p \
  "$HOME/.config" \
  "$HOME/.config/systemd/user" \
  "$HOME/.local/bin" \
  # "$HOME/.local/share/icons" \
  # "$HOME/.local/share/themes" \
  # "$HOME/.local/share/cursor-src" \
  "$HOME/Images/Wallpapers"

for dir in alacritty rofi hypr waybar dunst swaylock flameshot; do
  mkdir -p "$HOME/.config/$dir"
  cp -a "$repo/config/$dir/." "$HOME/.config/$dir/"
done

cp -a "$repo/config/systemd/user/." "$HOME/.config/systemd/user/"

cp -a "$repo/config/zsh/.zshrc" "$HOME/.zshrc"
cp -a "$repo/config/local-bin/." "$HOME/.local/bin/"
cp -a "$repo/config/icons/kzdot" "$HOME/.local/share/icons/"
cp -a "$repo/config/cursor-src/kzdot" "$HOME/.local/share/cursor-src/"
cp -a "$repo/config/themes/KzTheme" "$HOME/.local/share/themes/"
cp -a "$repo/assets/wallpapers/px2.png" "$HOME/Images/Wallpapers/px2.png"

chmod 755 "$HOME/.local/bin/"* "$HOME/.config/waybar/capslock.sh"

# gsettings set org.gnome.desktop.interface gtk-theme 'KzTheme'
# gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
# gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
# gsettings set org.gnome.desktop.interface font-name 'SF Pro Display 10'
# gsettings set org.gnome.desktop.interface cursor-theme 'kzdot'
# gsettings set org.gnome.desktop.interface cursor-size 24

systemctl --user daemon-reload
systemctl --user enable --now hypridle.service

printf 'Configuration installed. Log out and sign in to Hyprland again.\n'
