#!/usr/bin/env bash
set -euo pipefail

repo="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

sudo pacman -S --needed \
  hyprland xdg-desktop-portal-hyprland waybar dunst alacritty rofi flameshot \
  wl-clipboard cliphist swaybg hyprpolkitagent \
  brightnessctl playerctl pipewire pipewire-pulse wireplumber pavucontrol \
  hyprlock hypridle papirus-icon-theme fzf xdg-utils

mkdir -p \
  "$HOME/.config" \
  "$HOME/.config/systemd/user" \
  "$HOME/.local/bin"

for dir in alacritty rofi hypr waybar dunst flameshot; do
  mkdir -p "$HOME/.config/$dir"
  cp -a "$repo/config/$dir/." "$HOME/.config/$dir/"
done

cp -a "$repo/config/systemd/user/hypridle.service" "$HOME/.config/systemd/user/"

scripts=(
  audio-menu
  audio-output-menu
  brightness-control
  clipboard-menu
  file-picker
  lockscreen
  power-menu
  shortcut-center
  volume-control
)

for script in "${scripts[@]}"; do
  install -Dm755 "$repo/config/local-bin/$script" "$HOME/.local/bin/$script"
done

chmod 755 "$HOME/.config/waybar/capslock.sh"

systemctl --user daemon-reload
systemctl --user enable --now hypridle.service

printf 'Configuration installed. Log out and sign in to Hyprland again.\n'
