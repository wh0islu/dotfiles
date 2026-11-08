<div align="center">
  <samp>hyprland + waybar + alacritty + rofi + zsh + neovim</samp><br>
  <samp>new setup (hypr):  ૮( • ᴗ •)っ🧃</samp>
</div>
<br>

<samp>set up Arch + Hyprland (single script, packages + configs + fonts + neovim)</samp>
```bash
./install-arch.sh
```

<samp>set up i3 + Polybar on Debian/Ubuntu-based systems</samp>
```bash
./install-i3-polybar-apt.sh
```
Use `--dry-run` to preview package installation and config links. The apt
repositories must provide Polybar 3.7.0 or newer.

Security tools have a [separate installer](setup/README.md) that detects Ubuntu
or Arch Linux. For a server:

```bash
./setup/sectools.sh --server --dry-run
```

<samp>per-machine settings (monitor, keyboard, wallpaper)</samp>
```bash
cp config/hypr/local.lua.example config/hypr/local.lua
```

<br>
<samp>keyboard shortcuts</samp>:

- `Super + F1`: manual keyboard shortcuts
- `Super + Shift + E`: file picker with FZF
- `Super + A`: audio controls
- `Super + Shift + W`: wallpaper picker
- `Super + Shift + S`: screenshot
- `Super + Shift + L`: lock screen
- `Super + Shift + P`: power and session


----

<h6 align="center">
  <a href="https://raw.githubusercontent.com/@@@@@@@@@@@@@@@/dotfiles/edit/main/LICENSE">MIT</a>
  © wired
</h6>
