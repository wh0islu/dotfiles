-- =========================================================
-- ToggleTerm
-- =========================================================

require("toggleterm").setup({
	size = 12,

	direction = "horizontal",

	start_in_insert = true,
	persist_mode = false,
	persist_size = true,

	-- Prevent ToggleTerm from automatically changing
	-- the terminal color.
	shade_terminals = false,
})

local Terminal = require("toggleterm.terminal").Terminal

local PANEL_HEIGHT = 12

-- =========================================================
-- Codex
-- =========================================================

local codex_cmd = "codex"

-- =========================================================
-- Editor window
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
-- Terminal appearance
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
-- Position below the editor
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
-- Panel toggle
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
			"No editor window found.",
			vim.log.levels.WARN
		)

		return
	end

	terminal_targets[term.id] = target

	-- Avoid displaying the intermediate layout
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
			"Error opening terminal: "
			.. tostring(err),
			vim.log.levels.ERROR
		)

		return
	end

	vim.cmd("redraw")
end

-- =========================================================
-- Main terminal
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
			"lazygit is not installed.",
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
-- Always enter terminals in input mode
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

-- Main terminal
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
		desc = "Open terminal",
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
		desc = "Run Django runserver",
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
		desc = "Run npm run dev",
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
		desc = "Open Lazygit",
		noremap = true,
		silent = true,
	}
)

vim.keymap.set(
	"n",
	"<leader>gt",
	toggle_lazygit,
	{
		desc = "Open Lazygit",
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
		desc = "Open Codex sidebar",
		noremap = true,
		silent = true,
	}
)

vim.keymap.set(
	"n",
	"<leader>ac",
	open_codex,
	{
		desc = "Open Codex in project",
		noremap = true,
		silent = true,
	}
)

vim.keymap.set(
	"n",
	"<leader>ak",
	close_codex,
	{
		desc = "Close Codex",
		noremap = true,
		silent = true,
	}
)

vim.keymap.set(
	"n",
	"<leader>ar",
	restart_codex,
	{
		desc = "Restart Codex",
		noremap = true,
		silent = true,
	}
)
