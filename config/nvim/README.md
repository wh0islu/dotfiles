# My Neovim Configuration

This modular Lua configuration lives in `~/.config/nvim`. The `init.lua` entry
point loads general options, keymaps, the project runner, plugins, and the local
`cyberia` theme.

## Foundation

Neovim uses `lazy.nvim` as its plugin manager and clones it automatically when
needed. Plugins are loaded on demand to keep startup lightweight. Opening
Neovim without a file displays a minimalist dashboard with project, file,
search, session, configuration, plugin-manager, and quit actions.

General options include UTF-8, line numbers, cursor-line highlighting, system
clipboard integration, true colors, four-space indentation, and a compact
command line.

## Keymaps

The leader key is `,`.

| Key | Action |
| --- | --- |
| `<C-r>` | Run the current file or project |
| `<C-s>` | Save |
| `<C-q>` | Close the current window |
| `<C-x>` | Save and close |
| `<C-n>` | Toggle NvimTree |
| `<C-t>` | Toggle the project terminal |
| `<leader>ai` | Toggle Codex in a side terminal |
| `<leader>ff` | Find files |
| `<leader>fg` | Search project text |
| `<leader>fb` | List buffers |
| `<leader>fo` | List recent files |
| `<leader>fd` | List diagnostics |
| `<leader>fs` | List document symbols |
| `<leader>fS` | List workspace symbols |
| `<leader>gt` | Open lazygit |
| `<leader>gg` | Open Fugitive Git status |
| `<leader>gc` | Open Git commit |
| `<leader>gP` | Push changes |
| `<leader>gl` | Pull changes |
| `<leader>gs` | Stage the current hunk |
| `<leader>gr` | Reset the current hunk |
| `<leader>gp` | Preview the current hunk |
| `<leader>gb` | Show blame for the current line |
| `<leader>qs` | Restore the project session |
| `<leader>ql` | Restore the last session |
| `<leader>qd` | Stop saving the current session |
| `<leader>ac` | Open Codex in the current project |
| `<leader>td` | Search TODO, FIXME, and NOTE comments |
| `<leader>ts` | Create a Spring Boot project |

## Project Runner

`lua/core/run.lua` provides `:Run` and `<C-r>`. It detects Django, Node.js,
Maven, Gradle, Rust, and Go projects before falling back to the current file
type. Python, C, Rust, Go, JavaScript, TypeScript, and Java files are supported.
The file is saved before its command runs in a horizontal ToggleTerm instance.

Java and Spring Boot commands use `/usr/lib/jvm/java-21-openjdk` when available.
For Maven projects, the runner finds the `@SpringBootApplication` class and
passes it explicitly to the Maven plugin.

Run `:NewSpringBoot` or press `<leader>ts` to create a project under
`~/Developments/Git`. Defaults are `web,validation,lombok,devtools`; JPA and
PostgreSQL are optional. A starter `HomeController` provides `GET /` and returns
`Spring Boot OK`.

## LSP, Completion, and Debugging

Mason configures `pyright`, `clangd`, `lua_ls`, and `ts_ls`. Java uses
`nvim-jdtls`, `java-debug-adapter`, and `java-test`, detects Maven or Gradle
roots, and stores workspaces in `~/.local/share/nvim/jdtls-workspace/`.

Completion uses LSP, LuaSnip, and the current buffer. `<C-b>` and `<C-f>` scroll
documentation, `<C-o>` opens completion, `<C-e>` cancels, and `<CR>` confirms.

Python debugging uses `~/.venv/bin/python3`, which must include `debugpy`.
`<F5>` continues, `<F10>` steps over, `<F11>` steps into, `<F12>` steps out,
and `<leader>b` toggles a breakpoint. DAP UI follows the debugging session.

## Interface

- NvimTree opens on the left, follows the focused file, and updates the working
  directory.
- Telescope provides file, text, buffer, diagnostic, and symbol pickers.
- Which-key shows the AI, Code, Debug, Git, and Terminal groups.
- Gitsigns provides hunk navigation, staging, resetting, previews, blame, and
  diffs.
- ToggleTerm keeps regular terminal and Codex sessions separate.
- Persistence restores project sessions and falls back to recent files.
- Bufferline shows numbered buffers and LSP diagnostics.
- Lualine shows Git, diagnostic, file, progress, and position information.

## Theme and Markdown

The active Cyberia theme is in `lua/themes/cyberia.lua` and uses `#080808` as
its base background.

## Plugin Reference

### Interface

- `lualine.nvim`: displays mode, file, Git, diagnostics, and cursor position in the status line.
- `bufferline.nvim`: displays open buffers as numbered tabs.
- `nvim-tree.lua`: provides the sidebar file explorer.
- `nvim-web-devicons`: supplies file icons used by other plugins.
- `which-key.nvim`: displays available keymaps after the leader key is pressed.
- `indent-blankline.nvim`: displays guides for indentation levels.
- `nvim-colorizer.lua`: previews color values such as `#080808` and `rgb()`.

### Search and Navigation

- `telescope.nvim`: searches files, text, buffers, symbols, and diagnostics.
- `telescope-ui-select.nvim`: renders Neovim selection menus through Telescope.
- `plenary.nvim`: provides shared Lua utilities required by Telescope and other plugins.
- `persistence.nvim`: saves and restores project sessions and open buffers.

### Editing

- `Comment.nvim`: comments and uncomments lines and selections.
- `nvim-autopairs`: automatically closes parentheses, brackets, braces, and quotes.
- `nvim-treesitter`: provides syntax-tree-aware highlighting and code analysis.
- `conform.nvim`: formats files with tools such as Ruff, Prettier, and Stylua.
- `todo-comments.nvim`: highlights and searches `TODO`, `FIXME`, `BUG`, and `NOTE` comments.

### Completion and Snippets

- `nvim-cmp`: provides the main completion menu.
- `cmp-buffer`: suggests words from the current buffer.
- `cmp-cmdline`: adds completion to the Neovim command line.
- `cmp-nvim-lsp`: adds LSP suggestions to `nvim-cmp`.
- `cmp-path`: completes file and directory paths.
- `cmp_luasnip`: exposes snippets through the completion menu.
- `LuaSnip`: expands and manages snippets.
- `friendly-snippets`: provides a ready-made snippet collection for many languages.

### Language Support

- `mason.nvim`: installs and manages language servers and development tools.
- `mason-lspconfig.nvim`: connects Mason-installed servers to Neovim LSP.
- `mason-tool-installer.nvim`: installs tools declared by the configuration.
- `nvim-lspconfig`: provides configurations for connecting Neovim to language servers.
- `nvim-jdtls`: provides specialized Java support for JDT LS, Maven, and Gradle projects.

### Git, Terminals, and AI

- `gitsigns.nvim`: shows changed lines and provides hunk staging, resetting, preview, and blame.
- `vim-fugitive`: provides Git commands and status views inside Neovim.
- `toggleterm.nvim`: manages project terminals, command runners, Codex, and lazygit.
- `claudecode.nvim`: integrates Claude Code into Neovim.
- `snacks.nvim`: provides UI components required by `claudecode.nvim`.

### Plugin Management

- `lazy.nvim`: installs, updates, lazily loads, and removes plugins.

### Mason Tools

- `basedpyright`: active Python language server for completion, diagnostics, and inlay hints.
- `pyright`: an additional Python language server; redundant while BasedPyright is active.
- `clangd`: language server for C and C++.
- `jdtls`: language server for Java.
- `lua-language-server`: language server for Lua and the Neovim configuration.
- `typescript-language-server`: language server for JavaScript and TypeScript.

### Unconfigured Residue

- `grug-far.nvim`: its directory is present in the Lazy data directory, but the plugin is not
  declared or loaded by this configuration. `:Lazy clean` can remove it.

## Useful Commands

| Command | Action |
| --- | --- |
| `:Lazy` | Open the plugin manager |
| `:Lazy sync` | Synchronize plugins |
| `:Mason` | Open Mason |
| `:checkhealth` | Check Neovim health |
| `:Format` | Format with the active LSP |
| `:Lint` | Open diagnostics in quickfix |
| `:ReloadConfig` | Reload the local configuration |
| `:Run` | Run the current file or project |

## Notes

- `lazy-lock.json` pins plugin versions.
- `nvim-treesitter` uses `master` for the classic `nvim-treesitter.configs` API.
- Markdown Treesitter is disabled to avoid parser and injection errors on newer
  Neovim versions; Markdown continues to use native highlighting.
