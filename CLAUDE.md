# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles for an Arch Linux + Hyprland desktop, used on more than one machine (a desktop and a ThinkPad). It is not an application — there is no build/lint/test toolchain. "Testing" a change means running `install-arch.sh` (ideally in a disposable Arch container, see `TEST.md`) and checking the result, or opening the affected app.

Everything under `config/` is deployed by **symlinking** into `~/.config/<app>` (plus `~/.zshrc`, `~/.local/bin/*`, `~/.config/starship.toml`, `~/.config/systemd/user/hypridle.service`). The deployed paths are symlinks, so editing either side edits the repo. Some apps write back to their own config (Flameshot does), which shows up as a dirty working tree.

## Entry point

- `./install-arch.sh [--dry-run] [--java] [--go] [--rust] [--nix] [--extras]` — the only installer. Installs packages (`pacman --noconfirm`), Nerd Fonts, zsh plugins, symlinks, Docker, `i2c-dev` and user services, then asks one question: reboot or not. The package/step list lives as comments in the script and is printed only with `--dry-run`, which exits without changing anything.
- Re-running is safe: a target that already exists and is not the expected symlink is moved to `<path>.bak-<timestamp>`, never deleted.
- Steps that need systemd as PID 1 (`docker.socket`, `hypridle.service`) are skipped with a warning when it isn't running, so the script works in containers and chroots.
- It must run as a normal user (it refuses root and uses `sudo` itself).

## Per-machine settings

`config/hypr/hyprland.lua` defaults to a generic machine (`monitor preferred`, `kb_layout us`). Machine-specific values go in `config/hypr/local.lua` (gitignored), which returns a table that overrides `monitors`, `kb_layout`, `kb_model` and `wallpaper`. `local.lua.example` is the template. Never hardcode a monitor name, refresh rate or keyboard model in `hyprland.lua`.

## Neovim (`config/nvim/`)

See `config/nvim/README.md` (Portuguese) for the canonical description.

- `init.lua` loads `core.*` modules, then `plugins.markdown` and `themes.cyberia`. Leader is `,`.
- lazy.nvim bootstraps itself on first launch and installs the revisions pinned in `lazy-lock.json`. Mason installs basedpyright, clangd, lua_ls, ts_ls and jdtls; `mason-lspconfig` skips auto-install when there is no UI (`--headless`), so headless tests don't prove LSP installation.
- Ruff, StyLua and Prettier come from pacman, not Mason.
- `core/environment.lua` resolves `NVIM_PROJECTS_DIR` (default `~/Developments/Git`) and the JDK (`NVIM_JAVA_HOME` → `JAVA_HOME` → JDK 21 under `/usr/lib/jvm`).

## Other configs

- `hypr/hyprland.lua` uses Hyprland's native Lua API (`hl.*`). The startup hook starts waybar, dunst and `swaybg` with the `wallpaper` from `local.lua` or the first image in `~/Images/Wallpapers`, falling back to a solid color.
- `waybar/` — `custom/capslock` is a long-running script that prints only on state change; polling it at 0.15s kept waybar at ~15% CPU. Keep custom modules event- or signal-driven. `custom/brightness` runs `brightness-control status` once and refreshes on `SIGRTMIN+9`.
- `local-bin/brightness-control` uses `brightnessctl` when `/sys/class/backlight` exists (laptop) and `ddcutil` over DDC/CI otherwise (external monitor). Its module stays hidden when neither works.
- `flameshot/flameshot.ini` has no `savePath` on purpose: Flameshot does not expand `$HOME`/`~`, and an invalid value makes it rewrite the file with an absolute path. The save folder is passed with `--path` in the screenshot binds (`hyprland.lua`, `shortcut-center`).
- `dunst/dunstrc` — the scripts notify with `-a System`, matched by the `[system]` rule. `notify-send` comes from `libnotify`.
- `zsh/.zshrc` — `LS_COLORS` is built from the `kz` palette in truecolor; there is no `dircolors` call.
- `kz/palette.conf` is the shared color reference (alacritty, waybar, dunst and `LS_COLORS` use these values by hand).
- `assets/wallpapers/` is versioned and symlinked into `~/Images/Wallpapers`.

Keybindings and menu scripts are wired only by path: a bind in `hyprland.lua` or `waybar/config.jsonc` calls a script in `local-bin/`, and the shortcut list is repeated in `local-bin/shortcut-center` (Super+F1 menu) and `README.md`. Change them together.
