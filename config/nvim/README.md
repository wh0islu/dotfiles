# My Neovim Configuration

This configuration lives in `~/.config/nvim` and uses modular Lua files.
The entry point is `init.lua`, which loads general options, keybindings, the
runner, plugins, and the local `cyberia` theme.

## Installation and dependencies

This configuration is part of the repository's unified installation process.
From the repository root on an Arch machine:

```bash
./install-arch.sh                            # packages, fonts, configs, nvim symlink, etc.
./install-arch.sh --java --go --rust --nix --extras
```

The installer uses `pacman -Syu --needed --noconfirm` (including a system
upgrade without pacman confirmation) and symlinks `config/nvim` to
`~/.config/nvim`. Existing configurations are backed up instead of deleted.
Language groups are optional. `--extras` installs lazygit and Poetry.
Claude Code and the `codex` CLI must be on PATH to use their keybindings.

When Neovim opens, Lazy installs the plugins. Use `:Lazy restore` to apply the
revisions in `lazy-lock.json`. Open a file to trigger file-dependent setup and
check `:Mason` and `:checkhealth`. Mason installs basedpyright, clangd, lua_ls,
ts_ls, and jdtls; the script installs Ruff, StyLua, and Prettier. JDTLS requires
a compatible JDK; `--java` provides JDK 21. Treesitter parsers are installed
when files are opened.

## Local settings

Optional shell variables, set before opening Neovim:

```bash
export NVIM_PROJECTS_DIR="$HOME/Projects"
export NVIM_JAVA_HOME="/path/to/your/jdk-21"
```

The dashboard and Spring use `NVIM_PROJECTS_DIR`, defaulting to
`~/Developments/Git`. Java checks, in order, `NVIM_JAVA_HOME`, `JAVA_HOME`, a
JDK 21 installation under `/usr/lib/jvm`, or `java` on PATH. JDK paths must
contain an executable `bin/java`. Choose a JDK compatible with the installed
JDTLS version.

The format-on-save timeout is 1000 ms. For files that need more time, set
`vim.g.format_timeout_ms = 3000` before loading plugins in `init.lua`.
Use `:ConformInfo` for diagnostics.

## Structure

```text
init.lua
lazy-lock.json
lua/
  core/
    dashboard.lua
    commands.lua
    diagnostics.lua
    sets.lua
    map.lua
    run.lua
    plugins.lua
  plugins/
    bufferline.lua
    claudecode.lua
    cmp.lua
    colorizer.lua
    comment.lua
    conform.lua
    fugitive.lua
    gitsigns.lua
    java.lua
    lualine.lua
    markdown.lua
    mason.lua
    ntree.lua
    persistence.lua
    telescope.lua
    todo_comments.lua
    toggleterm.lua
    which_key.lua
  themes/
    cyberia.lua
    kaizen.lua
```

## Basics

Neovim uses `lazy.nvim` as its plugin manager. If Lazy is missing from
`~/.local/share/nvim/lazy/lazy.nvim`, it is cloned automatically.

Plugins load on demand where possible. Telescope, NvimTree, ToggleTerm,
completion, Git helpers, and other tools load only when a command, key, or
event needs them. This keeps startup light. LSP configurations are registered
at startup; servers start according to the filetype and project root.

When Neovim opens without a file, `lua/core/dashboard.lua` creates a minimal
start screen with a centered ASCII logo and a quick-action menu.

The main options are in `lua/core/sets.lua`:

- UTF-8 encoding
- Line numbers enabled
- Cursor line enabled
- System clipboard integration through `unnamedplus`
- `termguicolors` enabled
- Tabline always visible
- Indentation width of 4
- `cmdheight = 0` for a compact command line

## Keybindings

The leader key is `,`.

| Shortcut | Action |
| --- | --- |
| `<C-r>` | Run `Run()` for the current file |
| `<C-s>` | Save with `:w!` |
| `<C-q>` | Close the current window with `:q` |
| `<C-x>` | Save and close with `:x` |
| `g` | Go to the start of the file with `gg` |
| `<C-n>` | Toggle NvimTree |
| `<leader>ee` | Create a file in the current directory (prompts for a name) |
| `<leader>ed` | Create a directory in the current directory (prompts for a name) |
| `<C-t>` | Toggle ToggleTerm |
| `<leader>ai` | Toggle Codex in a side terminal |
| `<C-f>` | Open Telescope |
| `<leader>f` | Open the Find group in which-key |
| `<leader>ff` | Find files with Telescope |
| `<leader>fg` | Search text in the current file with Telescope |
| `<leader>fb` | List open buffers |
| `<leader>fo` | List recent files |
| `<leader>fd` | List diagnostics |
| `<leader>fs` | List current document symbols |
| `<leader>fS` | List workspace symbols |
| `<leader>fr` | Replace in quickfix files (`:cfdo`) |
| `<leader>gt` | Open lazygit |
| `<leader>gg` | Open Git status with Fugitive |
| `<leader>gc` | Open Git commit |
| `<leader>gP` | Run Git push |
| `<leader>gl` | Run Git pull |
| `<leader>gs` | Stage the current hunk |
| `<leader>gr` | Reset the current hunk |
| `<leader>gp` | Preview the current hunk |
| `<leader>gb` | Show blame for the current line |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>ld` | List diagnostics in quickfix |
| `<leader>lh` | Toggle inlay hints (any supporting LSP) |
| `<leader>/` | Toggle comments for the line or selection |
| `<C-k>` while inserting Python | Show the current function signature |
| `<leader>qs` | Restore the project session |
| `<leader>ql` | Restore the last session |
| `<leader>qd` | Disable saving the current session |
| `<leader>ac` | Open Codex in the current project |
| `<leader>ar` | Restart Codex |
| `<leader>ak` | Close Codex |
| `<leader>cc` | Toggle Claude |
| `<leader>cs` | Send the visual selection to Claude |
| `<leader>cw` | Focus the Claude window |
| `<leader>td` | Find TODO/FIXME/NOTE with Telescope |
| `<leader>tr` | Run `python manage.py runserver` |
| `<leader>tn` | Run `npm run dev` |
| `<leader>ts` | Create a standardized Spring Boot project |
| `<leader>tg` | Open lazygit |
| `<C-w>` in a terminal | Leave terminal mode and switch windows |
| `<C-w>` in normal mode | Switch windows |
| `<Tab>` | Next buffer in Bufferline |
| `<S-Tab>` | Previous buffer in Bufferline |
| `K` | Open LSP hover on demand |
| `gd` | Go to definition through LSP |
| `<leader>ca` | LSP code action |
| `p` on the dashboard | List repositories in `~/Developments/Git` |
| `f` on the dashboard | Find files in the current project |
| `g` on the dashboard | Search text in the current project |
| `s` on the dashboard | Restore a session; fall back to recent files |
| `c` on the dashboard | Open `~/.config/nvim/init.lua` |
| `L` on the dashboard | Open Lazy |
| `q` on the dashboard | Quit Neovim |

## Runner

`lua/core/run.lua` defines the `:Run` command, also called by `<C-r>`.

The runner first tries to detect the project type:

| Project file | Command |
| --- | --- |
| `manage.py` + Poetry project (with Poetry installed) | `poetry run python manage.py runserver` |
| `manage.py` | `python manage.py runserver` |
| `package.json` with a `dev` or `start` script | `npm run dev` or `npm run start` |
| `mvnw` + `pom.xml` | `sh ./mvnw spring-boot:run` |
| `gradlew` + `build.gradle` | `sh ./gradlew bootRun` |
| `pom.xml` | `mvn spring-boot:run` |
| `build.gradle` | `gradle bootRun` |
| `Cargo.toml` | `cargo run` |
| `go.mod` | `go run .` |

The runner treats the current working directory as the root. Maven requires
`spring-boot-maven-plugin` in `pom.xml`; Gradle requires
`org.springframework.boot` in `build.gradle` or `build.gradle.kts`. Inherited
or indirect declarations are not detected. Without that declaration, or
without `dev`/`start` scripts in package.json, the runner warns and does not
execute another command. The JavaScript package manager remains npm.

JDK selection follows the Local settings section.

In Maven Spring Boot projects, the runner also looks for the class annotated
with `@SpringBootApplication` in `src/main/java` and explicitly passes
`-Dspring-boot.run.main-class=...`. This avoids Maven plugin failures when
inferring the main class.

If no known project is found, it runs the current file according to its type:

| Extension | Command |
| --- | --- |
| `.py` | `python3 file.py` or `poetry run python file.py` |
| `.c` | `gcc file.c -o output && ./output` |
| `.rs` | `rustc file.rs -o output && ./output` |
| `.go` | `go run file.go` |
| `.js` | `node file.js` |
| `.ts` | `npx ts-node file.ts` |
| `.java` | `java file.java` |

Before execution, the current file is saved automatically and the command
runs in a horizontal ToggleTerm terminal.

## Spring Boot

Create a standardized Spring Boot project:

```vim
:NewSpringBoot
```

Shortcut:

```text
,ts
```

The command creates the project in `~/Developments/Git` using Spring Initializr.
The default dependencies are:

```text
web,validation,lombok,devtools
```

Database support is disabled by default to avoid an initial DataSource error.
Answering `y` to `Include JPA/PostgreSQL?` also includes:

```text
data-jpa,postgresql
```

The command also creates an initial `HomeController` with `GET /`, returning
`Spring Boot OK`. This avoids the Whitelabel 404 page when opening
`http://localhost:8080` immediately after starting the project.

## Plugins

Plugins declared in `lua/core/plugins.lua`:

- `nvim-lualine/lualine.nvim`: statusline
- `akinsho/bufferline.nvim`: tabs/buffers at the top
- `NvChad/nvim-colorizer.lua`: CSS, RGB, HSL, and hex color previews
- `numToStr/Comment.nvim`: toggle comments with `<leader>/` (default plugin mappings disabled)
- `folke/which-key.nvim`: visual menu for leader keybindings
- `lewis6991/gitsigns.nvim`: Git signs and hunk actions
- `folke/todo-comments.nvim`: highlight and search TODO/FIXME/NOTE
- `folke/persistence.nvim`: sessions per project
- `nvim-telescope/telescope.nvim`: search and pickers
- `nvim-telescope/telescope-ui-select.nvim`: UI selection using Telescope
- `nvim-tree/nvim-tree.lua`: file explorer
- `akinsho/toggleterm.nvim`: integrated terminal
- `tpope/vim-fugitive`: Git integration
- `williamboman/mason.nvim`: LSP tool installer
- `williamboman/mason-lspconfig.nvim`: Mason + LSP integration
- `WhoIsSethDaniel/mason-tool-installer.nvim`: additional Mason tools
- `neovim/nvim-lspconfig`: LSP server configurations
- `mfussenegger/nvim-jdtls`: Java LSP through Eclipse JDT LS
- `hrsh7th/nvim-cmp`: autocomplete
- `L3MON4D3/LuaSnip`: snippets
- `saadparwaiz1/cmp_luasnip`: LuaSnip completion source
- `rafamadriz/friendly-snippets`: ready-made snippets
- `nvim-treesitter/nvim-treesitter`: parser-based highlighting for Lua, Python, JS, TS, and C
- `coder/claudecode.nvim`: Claude Code CLI integration through WebSocket/MCP
- `folke/snacks.nvim`: dependency of claudecode.nvim
- `windwp/nvim-autopairs`: automatically close parentheses, quotes, and brackets
- `lukas-reineke/indent-blankline.nvim`: indentation guides

## LSP

LSP is configured in `lua/plugins/mason.lua`.

Servers ensured by Mason:

- `basedpyright`
- `clangd`
- `lua_ls`
- `ts_ls`

`lua_ls` recognizes `vim` as a global, uses the configuration's own `lua`
directory as a library, and disables telemetry.

`basedpyright` detects the project's Python automatically: it first checks
`$VIRTUAL_ENV`, then looks for `.venv/bin/python` or `venv/bin/python` under
the project root (`pyproject.toml`, `setup.py`, `setup.cfg`,
`requirements.txt`, `Pipfile`, or `pyrightconfig.json`).

`ruff` is also enabled as an LSP outside Mason: it uses the system `ruff`
executable (like conform.nvim's external formatters) for diagnostics, with
hover disabled to avoid duplicating basedpyright's hover.
See [Python](#python) for details.

Java uses `nvim-jdtls` instead of the generic `lspconfig` handler. When a
`.java` file opens, it looks for a Maven/Gradle project using `pom.xml`, `mvnw`,
`build.gradle`, `gradlew`, or `.git`, creates a workspace under
`~/.local/share/nvim/jdtls-workspace/`, and uses the Mason-installed tool:

- `jdtls`

`jdtls` shares the runner's Java selection (see Local settings).

Java keybindings:

| Shortcut | Action |
| --- | --- |
| `<leader>jo` | Organize imports |
| `<leader>jv` | Extract a variable in visual mode |
| `<leader>jc` | Extract a constant in visual mode |
| `<leader>jm` | Extract a method in visual mode |

Additional keybindings when an LSP attaches to the buffer:

| Shortcut | Action |
| --- | --- |
| `gD` | Declaration |
| `gd` | Definition |
| `K` | Hover |
| `gi` | Implementation |
| `<space>wa` | Add a workspace folder |
| `<space>wr` | Remove a workspace folder |
| `<space>wl` | List workspace folders |
| `<space>D` | Type definition |
| `<space>rn` | Rename |
| `<space>ca` | Code action |
| `gr` | References |
| `<space>f` | Async formatting |

## Autocomplete

Autocomplete is configured in `lua/plugins/cmp.lua`.

Active sources:

- LSP through `nvim_lsp`
- Snippets through `luasnip`
- Current buffer

Completion menu keybindings:

| Shortcut | Action |
| --- | --- |
| `<C-b>` | Scroll documentation up |
| `<C-f>` | Scroll documentation down |
| `<C-o>` | Open completion |
| `<C-e>` | Close/cancel |
| `<CR>` | Confirm the selected item |

## Interface

### NvimTree

Configured in `lua/plugins/ntree.lua`:

- Width of 30 columns
- Left side
- No signcolumn
- Follow the focused file
- Update cwd according to the focused file
- No window picker when opening a file
- Do not hijack directories

### Quick file creation

Configured in `lua/core/newfile.lua`, shortcut `<leader>ee`.

Prompts for a filename (accepts paths containing `/` to create subdirectories)
and creates an empty file in the current directory:

- When NvimTree is focused, use the directory of the item under the cursor
  (the item itself if it is a directory, or the selected file's parent).
- Otherwise, use the directory of the file being edited.
- Without a named buffer, use the current working directory.

After creation, open the file for editing (in a window separate from NvimTree
if needed) and reload the file tree if it is open.

### Quick directory creation

Configured in `lua/core/newdir.lua`, shortcut `<leader>ed`.

Uses the same location logic as `<leader>ee` (item under the NvimTree cursor,
current file's directory, or working directory), but creates a directory
(`mkdir -p`, accepting `/` for nested subdirectories) instead of a file.
After creation, reload the file tree and focus the new directory if NvimTree
is open.

### Telescope

Configured in `lua/plugins/telescope.lua` with `ui-select` in dropdown mode.

On the dashboard, `p` uses Telescope to list repositories found under
`~/Developments/Git`. Selecting a project changes Neovim's working directory
to that repository and opens NvimTree.

Main keybindings:

- `<leader>ff`: find files
- `<leader>fg`: search text in the current file
- `<leader>fb`: list buffers
- `<leader>fo`: list recent files
- `<leader>fd`: list diagnostics
- `<leader>fs`: list current document symbols
- `<leader>fS`: list workspace symbols

### Project search and replace

No dedicated plugin: this uses Telescope and Vim's native quickfix list.

1. Search with `<leader>fg` (or any other Telescope picker).
2. Press `<C-q>` in the results window, in insert or normal mode, to send all
   results to quickfix and open the list (or select several with `<Tab>` first).
3. `<leader>fr` (`lua/core/quickfix_replace.lua`) prompts for the search and
   replacement text, then runs `:cfdo %s/search/replacement/g | update` in all
   files in the quickfix list.

### Autopairs

Configured in `lua/plugins/autopairs.lua`, using `windwp/nvim-autopairs`.
Automatically closes parentheses, brackets, braces, and quotes while typing,
using Treesitter (`check_ts = true`) to avoid incorrect pairs inside strings
and comments. Integrated with `nvim-cmp`: accepting a function in the completion
menu also closes the parentheses.

### Indent guides

Configured in `lua/plugins/indent_blankline.lua`, using
`lukas-reineke/indent-blankline.nvim`. Subtle indentation guides with a
highlight for the current scope. Disabled in NvimTree, the dashboard, Lazy,
Mason, help, and terminal buffers.

### Diagnostics

Styled in `lua/core/diagnostics.lua` through `vim.diagnostic.config()`:
subtle signs, virtual text without the source name (`[basedpyright]`, etc.),
and a floating window with rounded borders matching hover windows.

### Which-key

Configured in `lua/plugins/which_key.lua`.

Pressing `,` displays a panel with available keybindings. The main groups are
AI, Code, Git, and Terminal.

### Gitsigns

Configured in `lua/plugins/gitsigns.lua`.

- Show signs for added, changed, and removed lines
- `]h` and `[h` navigate hunks
- `<leader>gs` stages the hunk
- `<leader>gr` resets the hunk
- `<leader>gp` previews the hunk
- `<leader>gb` shows line blame
- `<leader>gd` opens the file diff

### Python

`basedpyright` automatically shows the function signature in a floating window
when typing `(` or `,`. Use `<C-k>` in insert mode to open it manually.
Only argument names appear inline; variable and return types stay hidden to
keep the code uncluttered. Use `<leader>lh` to toggle inlay hints.

The project's virtual environment (`$VIRTUAL_ENV`, `.venv/`, or `venv/` at the
root) is detected automatically for basedpyright, and the environment name
appears in Lualine for Python files. Lint diagnostics come from `ruff` (a
separate LSP); formatting uses `ruff_format` through conform.nvim.

### Todo comments

Configured in `lua/plugins/todo_comments.lua`.

Highlights `TODO`, `FIXME`, `BUG`, `HACK`, `NOTE`, `INFO`, `WARN`, and `WARNING`.
Use `<leader>td` to search for these markers with Telescope.

### ToggleTerm

Configured in `lua/plugins/toggleterm.lua`:

- Size 12
- Horizontal direction
- Native plugin shortcut: `<C-\>`
- `<C-t>` opens a horizontal terminal for project commands
- `<leader>ai` opens Codex in a larger vertical side terminal in the current directory
- `<leader>ac` opens Codex in the current project
- `<leader>ar` restarts Codex
- `<leader>ak` closes Codex
- `<leader>tr` runs `python manage.py runserver`
- `<leader>tn` runs `npm run dev`
- `<leader>tg` or `<leader>gt` opens lazygit
- The regular terminal and Codex terminal use separate sessions
- The regular terminal sits at the bottom; Codex sits on the right

### Claude

Configured in `lua/plugins/claudecode.lua`, using `coder/claudecode.nvim`.
Unlike Codex, which runs in a regular terminal, this plugin connects the
`claude` CLI to Neovim through WebSocket/MCP, allowing Claude to receive the
current buffer/selection as context without copying and pasting.

Prerequisite: the `claude` CLI (Claude Code) installed and configured.

Keybindings:

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<leader>cc` | normal | Toggle Claude |
| `<leader>cs` | visual | Send the selection to Claude |
| `<leader>cw` | normal | Focus the Claude window |

Additional commands without a dedicated shortcut:

- `:ClaudeCodeAdd <file>` adds an entire file to the context
- `:ClaudeCodeSelectModel` changes the model used by the session

### Persistence

Configured in `lua/plugins/persistence.lua`.

- `<leader>qs` restores the current project's session
- `<leader>ql` restores the last session
- `<leader>qd` disables saving the current session

On the dashboard, `s` tries to restore the current project's session. If the
plugin is unavailable, it falls back to `Telescope oldfiles`.

### Fugitive

Configured in `lua/plugins/fugitive.lua`.

- `<leader>gg` opens `:Git`
- `<leader>gc` opens `:Git commit`
- `<leader>gP` runs `:Git push`
- `<leader>gl` runs `:Git pull`

### Bufferline

The buffer bar stays hidden while only one file is open.

Configured in `lua/plugins/bufferline.lua`:

- Buffers numbered in order
- LSP diagnostics
- No close icons
- `slant` separators
- NvimTree offset labeled `File Explorer`

### Lualine

Configured in `lua/plugins/lualine.lua`:

- Global statusline
- Shows mode, branch, diff, diagnostics, file, Python virtual environment
  (only for `.py` files), filetype, progress, and position
- Disabled for NvimTree

## Cyberia theme

The active theme is in `lua/themes/cyberia.lua`.

Cyberia's base background is:

```text
#080808
```

The old theme remains in `lua/themes/kaizen.lua`.

The following palette documents the old Kaizen theme:

| Usage | Color |
| --- | --- |
| Background | `#111318` |
| Text | `#E6EAF0` |
| Comments/docstrings | `#5F6878` |
| Strings | `#7ED7A8` |
| Functions | `#8FB7FF` |
| Keywords | `#C7A4FF` |
| Types | `#79D7D2` |
| Numbers/booleans | `#FFB86C` |
| Errors | `#FF6B6B` |
| Warnings | `#F2C66D` |

The theme covers base Vim groups, Treesitter, diagnostics, NvimTree, Telescope,
completion, Bufferline, statusline, floating windows, and selections.

## Markdown

Configured in `lua/plugins/markdown.lua`:

- Folding disabled
- Conceal disabled
- Frontmatter enabled

## Terminal

The primary terminal configured in this environment is Alacritty.

File:

```text
~/.config/alacritty/alacritty.toml
```

Relevant configuration values documented for the terminal:

- Font: `JetBrainsMono Nerd Font`
- Size: `11.5`
- Background: `#111318`
- Text: `#E6EAF0`
- Opacity: `1.0`
- Padding: `x = 14`, `y = 12`
- Window decorations: `None`

## Useful commands

Open the plugin manager:

```vim
:Lazy
```

Synchronize plugins:

```vim
:Lazy sync
```

Open Mason:

```vim
:Mason
```

Check Neovim health:

```vim
:checkhealth
```

Format the current buffer using the active LSP:

```vim
:Format
```

Open current buffer diagnostics in quickfix:

```vim
:Lint
```

Reload the local configuration without closing Neovim:

```vim
:ReloadConfig
```

Run the current file:

```vim
:Run
```

## Notes

- `lazy-lock.json` pins installed plugin versions.
- `nvim-treesitter` is pinned to the `master` branch because it retains the
  `nvim-treesitter.configs` API used by this configuration.
- Markdown Treesitter is disabled in `lua/plugins/markdown.lua` because the
  classic nvim-treesitter branch can cause parser/injection errors on newer
  Neovim versions. Markdown continues to use native syntax highlighting.
