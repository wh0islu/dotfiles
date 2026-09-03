-- =========================================================
-- ToggleTerm
-- =========================================================

require("toggleterm").setup({
	size = 12,

	direction = "horizontal",

	start_in_insert = true,
	persist_mode = false,
	persist_size = true,

	-- Impede o ToggleTerm de alterar automaticamente
	-- a cor do terminal.
	shade_terminals = false,
})

local Terminal = require("toggleterm.terminal").Terminal

local PANEL_HEIGHT = 12

-- =========================================================
-- Codex
-- =========================================================

local codex_bin =
"$HOME/.nvm/versions/node/v22.22.1/lib/node_modules/@openai/codex/bin/codex.js"

local node_bin =
"$HOME/.nvm/versions/node/v22.22.1/bin/node"

local codex_cmd =
	vim.fn.executable(node_bin) == 1
	and vim.fn.filereadable(codex_bin) == 1
	and (node_bin .. " " .. codex_bin)
	or "codex"

-- =========================================================
-- Janela do editor
-- =========================================================

local terminal_targets = {}

local function is_editor_window(win)
	if not vim.api.nvim_win_is_valid(win) then
		return false
	end

	local buf = vim.api.nvim_win_get_buf(win)

	local filetype = vim.bo[buf].filetype
	local buftype = vim.bo[buf].buftype

	return filetype ~= "NvimTree"
		and filetype ~= "toggleterm"
		and buftype ~= "terminal"
end

local function get_editor_window()
	local current = vim.api.nvim_get_current_win()

	if is_editor_window(current) then
		return current
	end

	for _, win in ipairs(
		vim.api.nvim_tabpage_list_wins(0)
	) do
		if is_editor_window(win) then
			return win
		end
	end

	return nil
end

-- =========================================================
-- Visual do terminal
-- =========================================================

local function apply_terminal_style(term)
	local win = term.window

	if not win then
		return
	end

	if not vim.api.nvim_win_is_valid(win) then
		return
	end

	vim.wo[win].winhighlight =
		"Normal:TerminalNormal,"
		.. "NormalNC:TerminalNormalNC,"
		.. "SignColumn:TerminalSignColumn,"
		.. "WinSeparator:TerminalWinSeparator"
end

-- =========================================================
-- Posicionamento abaixo do editor
-- =========================================================

local function place_terminal_below_editor(
	term,
	height
)
	local target = terminal_targets[term.id]
	local term_win = term.window

	if not target
		or not term_win
		or not vim.api.nvim_win_is_valid(target)
		or not vim.api.nvim_win_is_valid(term_win)
	then
		return
	end

	if target ~= term_win then
		vim.fn.win_splitmove(
			term_win,
			target,
			{
				vertical = false,
				rightbelow = true,
			}
		)
	end

	if vim.api.nvim_win_is_valid(term_win) then
		vim.api.nvim_win_set_height(
			term_win,
			height
		)

		apply_terminal_style(term)

		vim.api.nvim_set_current_win(
			term_win
		)

		vim.cmd("startinsert")
	end
end

-- =========================================================
-- Toggle do painel
-- =========================================================

local function toggle_terminal_panel(
	term,
	height
)
	if term:is_open() then
		term:toggle()
		return
	end

	local target = get_editor_window()

	if not target then
		vim.notify(
			"Nenhuma janela de editor encontrada.",
			vim.log.levels.WARN
		)

		return
	end

	terminal_targets[term.id] = target

	-- Evita mostrar o layout intermediário
	local old_lazyredraw = vim.o.lazyredraw

	vim.o.lazyredraw = true

	local ok, err = pcall(function()
		term:toggle(
			height,
			"horizontal"
		)
	end)

	vim.o.lazyredraw = old_lazyredraw

	if not ok then
		vim.notify(
			"Erro ao abrir terminal: "
			.. tostring(err),
			vim.log.levels.ERROR
		)

		return
	end

	vim.cmd("redraw")
end

-- =========================================================
-- Terminal principal
-- =========================================================

local project_terminal = Terminal:new({
	count = 11,

	display_name = "Terminal",

	direction = "horizontal",

	close_on_exit = false,

	hidden = true,

	on_open = function(term)
		place_terminal_below_editor(
			term,
			PANEL_HEIGHT
		)
	end,
})

-- =========================================================
-- Django
-- =========================================================

local runserver = Terminal:new({
	count = 12,

	display_name = "Runserver",

	cmd = "python manage.py runserver",

	direction = "horizontal",

	close_on_exit = false,

	hidden = true,

	on_open = function(term)
		place_terminal_below_editor(
			term,
			PANEL_HEIGHT
		)
	end,
})

-- =========================================================
-- npm run dev
-- =========================================================

local npm_dev = Terminal:new({
	count = 13,

	display_name = "npm dev",

	cmd = "npm run dev",

	direction = "horizontal",

	close_on_exit = false,

	hidden = true,

	on_open = function(term)
		place_terminal_below_editor(
			term,
			PANEL_HEIGHT
		)
	end,
})

-- =========================================================
-- Lazygit
-- =========================================================

local lazygit = Terminal:new({
	count = 14,

	display_name = "Lazygit",

	cmd = "lazygit",

	direction = "float",

	close_on_exit = true,

	hidden = true,

	on_open = function(term)
		apply_terminal_style(term)
		vim.cmd("startinsert")
	end,
})

local function toggle_lazygit()
	if vim.fn.executable("lazygit") == 0 then
		vim.notify(
			"lazygit nao esta instalado.",
			vim.log.levels.WARN
		)

		return
	end

	lazygit:toggle()
end

-- =========================================================
-- Codex
-- =========================================================

local function codex_width()
	return math.max(
		70,
		math.floor(
			vim.o.columns * 0.38
		)
	)
end

local codex = Terminal:new({
	count = 99,

	display_name = "Codex",

	cmd = codex_cmd,

	direction = "vertical",

	close_on_exit = false,

	hidden = true,

	on_open = function(term)
		vim.cmd("wincmd L")

		vim.cmd(
			"vertical resize "
			.. codex_width()
		)

		apply_terminal_style(term)

		vim.cmd("startinsert")
	end,
})

local function open_codex()
	codex.dir = vim.fn.getcwd()

	codex:toggle(
		codex_width(),
		"vertical"
	)
end

local function close_codex()
	if codex:is_open() then
		codex:close()
	end
end

local function restart_codex()
	if codex:is_open() then
		codex:close()
	end

	if codex.job_id then
		codex:shutdown()
	end

	codex.dir = vim.fn.getcwd()

	codex:open(
		codex_width(),
		"vertical"
	)
end

-- =========================================================
-- Sempre entrar no terminal em modo de digitação
-- =========================================================

vim.api.nvim_create_autocmd(
	"WinEnter",
	{
		group =
			vim.api.nvim_create_augroup(
				"ToggleTermInsertMode",
				{
					clear = true,
				}
			),

		callback = function()
			if
				vim.bo.filetype
				== "toggleterm"
			then
				vim.cmd("startinsert")
			end
		end,
	}
)

-- =========================================================
-- Keymaps
-- =========================================================

-- Terminal principal
vim.keymap.set(
	{ "n", "t" },
	"<C-t>",
	function()
		toggle_terminal_panel(
			project_terminal,
			PANEL_HEIGHT
		)
	end,
	{
		desc = "Abrir terminal",
		noremap = true,
		silent = true,
	}
)

-- Django
vim.keymap.set(
	"n",
	"<leader>tr",
	function()
		toggle_terminal_panel(
			runserver,
			PANEL_HEIGHT
		)
	end,
	{
		desc = "Rodar Django runserver",
		noremap = true,
		silent = true,
	}
)

-- npm run dev
vim.keymap.set(
	"n",
	"<leader>tn",
	function()
		toggle_terminal_panel(
			npm_dev,
			PANEL_HEIGHT
		)
	end,
	{
		desc = "Rodar npm run dev",
		noremap = true,
		silent = true,
	}
)

-- Lazygit
vim.keymap.set(
	"n",
	"<leader>tg",
	toggle_lazygit,
	{
		desc = "Abrir Lazygit",
		noremap = true,
		silent = true,
	}
)

vim.keymap.set(
	"n",
	"<leader>gt",
	toggle_lazygit,
	{
		desc = "Abrir Lazygit",
		noremap = true,
		silent = true,
	}
)

-- Codex
vim.keymap.set(
	"n",
	"<leader>ai",
	open_codex,
	{
		desc = "Abrir Codex lateral",
		noremap = true,
		silent = true,
	}
)

vim.keymap.set(
	"n",
	"<leader>ac",
	open_codex,
	{
		desc = "Abrir Codex no projeto",
		noremap = true,
		silent = true,
	}
)

vim.keymap.set(
	"n",
	"<leader>ak",
	close_codex,
	{
		desc = "Fechar Codex",
		noremap = true,
		silent = true,
	}
)

vim.keymap.set(
	"n",
	"<leader>ar",
	restart_codex,
	{
		desc = "Reiniciar Codex",
		noremap = true,
		silent = true,
	}
)
