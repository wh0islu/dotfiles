# Neovim configuration

Modular Lua config in `~/.config/nvim`. `init.lua` loads options, keymaps, the runner,
plugins (`lazy.nvim`, loaded on demand) and the local `cyberia` theme.

## Install

Installed by the repository's `./install-arch.sh` (add `--java --go --rust --nix --extras`
for optional languages; `--extras` adds lazygit and Poetry). Existing configs are backed up.

On first start, Lazy installs the plugins; `:Lazy restore` applies `lazy-lock.json`.
Mason installs basedpyright, clangd, lua_ls, ts_ls and jdtls; the installer provides Ruff,
StyLua and Prettier. Check with `:Mason` and `:checkhealth`.

Optional variables:

```bash
export NVIM_PROJECTS_DIR="$HOME/Projects"   # default: ~/Developments/Git
export NVIM_JAVA_HOME="/path/to/jdk-21"      # else JAVA_HOME, /usr/lib/jvm, or java on PATH
```

Format-on-save times out after 1000 ms; raise it with `vim.g.format_timeout_ms` in `init.lua`.

## Keybindings

Leader is `,`. Press it to see all groups in which-key.

| Area | Keys |
| --- | --- |
| Files | `<C-s>` save, `<C-q>` close, `<C-x>` save+close, `<C-n>` file tree, `<leader>ee`/`ed` new file/dir |
| Search | `<C-f>` Telescope, `<leader>ff` files, `fg` text, `fb` buffers, `fo` recent, `fs`/`fS` symbols, `fr` replace in quickfix |
| Git | `<leader>gg` status, `gc` commit, `gP` push, `gl` pull, `gs`/`gr`/`gp` stage/reset/preview hunk, `gb` blame, `gt` lazygit |
| LSP | `gd` definition, `gD` declaration, `gi` implementation, `gr` references, `K` hover, `<space>rn` rename, `<leader>ca` action, `[d`/`]d` diagnostics, `<leader>lh` inlay hints |
| Java | `<leader>jo` organize imports, `jv`/`jc`/`jm` extract variable/constant/method |
| Run | `<C-r>` run project/file, `<leader>tr` Django, `tn` npm dev, `ts` new Spring Boot project |
| Terminal & AI | `<C-t>` terminal, `<leader>ai`/`ac`/`ar`/`ak` Codex, `<leader>cc`/`cs`/`cw` Claude Code |
| Other | `<leader>/` comment, `<Tab>`/`<S-Tab>` buffers, `<leader>qs`/`ql`/`qd` sessions, `<leader>td` TODOs |

To search and replace across a project: search with Telescope, press `<C-q>` to send the
results to quickfix, then `<leader>fr`.

## Runner

`:Run` (`<C-r>`) saves the file and runs it in a ToggleTerm split. It detects the project in
the working directory first: Django (`manage.py`, via Poetry if present), npm `dev`/`start`,
Spring Boot with Maven or Gradle (wrapper preferred), Cargo and Go. Otherwise it runs the
current file: Python, C, Rust, Go, JavaScript, TypeScript or Java.

`:NewSpringBoot` (`,ts`) creates a project in `~/Developments/Git` with web, validation,
lombok and devtools, optionally JPA/PostgreSQL, plus a `GET /` controller.

## LSP and Python

Configured in `lua/plugins/mason.lua`. basedpyright picks the project's virtualenv
(`$VIRTUAL_ENV`, `.venv` or `venv`), shown in Lualine; Ruff provides lint diagnostics and
formatting. Java uses `nvim-jdtls` with a workspace in `~/.local/share/nvim/jdtls-workspace/`.

## Theme

Active theme: `lua/themes/cyberia.lua` (background `#080808`). The previous theme is kept in
`lua/themes/kaizen.lua`.

## Useful commands

`:Lazy`, `:Lazy sync`, `:Mason`, `:checkhealth`, `:Format`, `:Lint`, `:ReloadConfig`, `:Run`

## Notes

- `nvim-treesitter` is pinned to `master`, which keeps the `nvim-treesitter.configs` API used here.
- Markdown Treesitter is disabled to avoid parser errors on newer Neovim; native syntax is used.
