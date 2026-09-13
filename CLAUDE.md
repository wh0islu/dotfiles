# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles for an Arch Linux + Hyprland desktop. It is not an application — there is no build/lint/test toolchain in the traditional sense. "Testing" a change means running `install-arch.sh` (often inside a disposable Arch Docker container, see below) and verifying the resulting `~/.config/<app>` looks right, or opening the app itself (e.g. Neovim) and checking `:checkhealth` / `:Lazy` / `:Mason`. The repo previously also carried Ubuntu/FreeBSD/QEMU setup scripts and a menu-driven `install.sh`; these were removed as unused — the repo is Arch/Hyprland only now.

Config sources under `config/` are deployed into `~/.config/<app>` (and a few other XDG locations) by **symlinking**, all from the single entry point `install-arch.sh` — the same pattern `~/.config/nvim` already used before this script existed (`nvim -> /home/darth/dotfiles/config/nvim`). Always edit the source under `config/`, never a live copy in `~/.config` — every app's source of truth is `config/<app>` here, and the deployed path is just a symlink to it.

The repo targets **Hyprland only**. The legacy X11 stack (i3, kitty, polybar, picom, the standalone `40-libinput.conf`) has been removed from the repo entirely — it's still recoverable from git history, but there is nothing to reconcile with in the working tree.

## Entry point

- `./install-arch.sh [--dry-run] [--java] [--go] [--rust] [--nix] [--extras]` — the only entry point: on a fresh Arch machine this installs every package, font, dotfile symlink, zsh plugin, and systemd service needed, then asks a single question at the end (reboot now or not). Normal runs only print installation progress; the full list of packages/symlinks/steps is documented as comments in the script itself and only printed on screen when `--dry-run` is passed (which then exits without touching the system) — this exists because `pacman` runs with `--noconfirm`, which skips its own confirmation listing. Re-running it is safe: existing non-symlink targets are backed up (`<path>.bak-<timestamp>`), not overwritten or deleted. Language groups (`--java`/`--go`/`--rust`/`--nix`) and `--extras` (lazygit, Poetry) are additive and optional. AUR apps (discord/zen-browser) and their `config/desktops/*.desktop` entries are intentionally not installed yet — left for a later pass.
- `TEST.md` describes the Docker-based Arch test workflow: pull `archlinux`, run a privileged container, `docker cp` the repo in, run `./install-arch.sh` inside it. Use this instead of running the installer against the host when validating changes to it.

## Neovim config (`config/nvim/`)

This is the most actively developed and structured part of the repo (see `config/nvim/README.md`, in Portuguese, for the canonical description).

- Entry point `init.lua` loads, in order: `core.sets` → `core.plugins` → `core.map` → `core.run` → `core.spring` → `core.commands` → `core.newfile` → `core.newdir` → `core.quickfix_replace` → `core.diagnostics` → `core.dashboard` → `plugins.markdown` → `themes.cyberia`. Leader key is `,`.
- `lua/core/` holds non-plugin editor behavior (options, keymaps, custom commands, dashboard, diagnostics, file/dir creation helpers, a "spring"/runner module). `lua/plugins/` holds one file per plugin (lazy.nvim-style specs — LSP via Mason, completion, telescope, gitsigns, lualine, bufferline, toggleterm, conform for formatting, claudecode.lua for Claude Code integration, etc.). `lua/themes/` holds colorscheme definitions (`cyberia` is the active theme, `kaizen` also present).
- Plugin manager is lazy.nvim; `lazy-lock.json` pins plugin revisions — use `:Lazy restore` to sync to the lockfile.
- LSP/tooling is installed via Mason (basedpyright, clangd, lua_ls, ts_ls, jdtls) triggered on first file open; Ruff, StyLua, and Prettier are installed by `install-arch.sh` itself, not Mason. Treesitter parsers install lazily on file open.
- Java support needs a JDK 21 resolved in this order: `NVIM_JAVA_HOME` env var → `JAVA_HOME` → a JDK 21 under `/usr/lib/jvm` → `java` on PATH.
- Optional environment variables consumed by the config: `NVIM_PROJECTS_DIR` (used by dashboard and the Spring runner, defaults to `~/Developments/Git`), `NVIM_JAVA_HOME` (see above). `vim.g.format_timeout_ms` can be set before plugin load to raise the 1000ms default format-on-save timeout (see `:ConformInfo`).
- Claude Code and the `codex` CLI are expected on PATH for the corresponding editor integrations/keymaps to work.

## Other config areas (deploy targets under `config/`)

Each subdirectory under `config/` mirrors a single application's config directory verbatim and is deployed as a unit by `install-arch.sh` — there is no cross-app abstraction layer to understand:

- `hypr/` (Hyprland — note `hyprland.lua`: this Arch build of Hyprland reads native Lua config via the `hl.*` API, this is not a third-party wrapper; plus `hyprlock.conf`, `hypridle.conf`), `waybar/`, `rofi/`, `dunst/`, `alacritty/`, `flameshot/`, `starship/` (single file, symlinked to `~/.config/starship.toml`, not a directory symlink like the others), `zathura/`, `kz/` (a neutral color palette reference; not currently sourced by any other config), `zsh/`.
- `local-bin/` — standalone shell scripts (audio/brightness/power/lockscreen menus, shortcut center, file picker) symlinked into `~/.local/bin` and invoked from Hyprland/waybar keybindings.
- `desktops/` — custom `.desktop` launcher entries (discord, zen browser) pointing at `/opt/discord` and `/opt/zen`; **not currently deployed** by `install-arch.sh` (no AUR helper step either) — intentionally left out for now.
- `systemd/user/hypridle.service` — user-level systemd unit for the idle daemon.
- `windows/PROFILE` — a PowerShell profile for a separate Windows machine; unrelated to `install-arch.sh`.
- `hosts` — a personal `/etc/hosts` blocklist (distraction sites); not deployed by any script, kept as reference only.

Wallpapers: `assets/wallpapers/` holds the versioned wallpaper images (none committed by default); `install-arch.sh` symlinks whatever is in there into `~/Images/Wallpapers`, and `config/hypr/hyprland.lua`'s startup hook picks the first file found there via `swaybg`, falling back to a solid color when the directory is empty.

When changing a keybinding or menu script, check both `config/hypr/hyprland.lua` (or `waybar/config.jsonc`) for the binding and `config/local-bin/` for the script it invokes — they are wired together only by matching script names/paths, not by any indirection layer.
