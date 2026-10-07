local opts = {
	noremap = true,
	silent = true,
}

-- =========================================================
-- Run
-- =========================================================

vim.keymap.set("n", "<C-r>", function()
	Run()
end, opts)

-- =========================================================
-- Files
-- =========================================================

vim.keymap.set("n", "<C-s>", "<cmd>w!<CR>", opts)
vim.keymap.set("n", "<C-q>", "<cmd>q<CR>", opts)
vim.keymap.set("n", "<C-x>", "<cmd>x<CR>", opts)

-- =========================================================
-- NvimTree
-- =========================================================

vim.keymap.set("n", "<C-n>", function()
	pcall(function()
		require("lazy").load({
			plugins = {
				"nvim-tree.lua",
			},
		})
	end)

	require("nvim-tree.api").tree.toggle({
		focus = true,
		find_file = true,
	})
end, {
	desc = "Open File Explorer",
	silent = true,
})

-- =========================================================
-- Telescope
-- =========================================================

local function project_root()
	local filename = vim.api.nvim_buf_get_name(0)

	local start_dir

	if filename ~= "" then
		start_dir = vim.fs.dirname(filename)
	else
		start_dir = vim.fn.getcwd()
	end

	return vim.fs.root(start_dir, {
		".git",
		"pyproject.toml",
		"package.json",
		"go.mod",
	}) or vim.fn.getcwd()
end

-- =========================================================
-- Ctrl + F
-- Search the current file
-- =========================================================

vim.keymap.set("n", "<C-f>", function()
	local buftype = vim.bo.buftype
	local filetype = vim.bo.filetype

	-- Avoid searching special buffers.
	if buftype ~= "" then
		vim.notify(
			"Ctrl+F is only available in file buffers.",
			vim.log.levels.INFO
		)

		return
	end

	if filetype == "NvimTree"
		or filetype == "kaizen_dashboard"
		or filetype == "lazy"
		or filetype == "toggleterm"
	then
		return
	end

	require("telescope.builtin").current_buffer_fuzzy_find({
		prompt_title = "Search file",
	})
end, {
	desc = "Search current file",
	silent = true,
})

-- =========================================================
-- Ctrl + Shift + F
-- Alacritty sends this as F13
-- Search contents across the entire project
-- =========================================================

vim.keymap.set("n", "<F13>", function()
	require("telescope.builtin").live_grep({
		prompt_title = "Search project",
		cwd = project_root(),
	})
end, {
	desc = "Search text in project",
	silent = true,
})

-- =========================================================
-- Ctrl + P
-- Search files by name
-- =========================================================

vim.keymap.set("n", "<C-p>", function()
	require("telescope.builtin").find_files({
		prompt_title = "Find files",
		cwd = project_root(),
		hidden = true,
	})
end, {
	desc = "Find files in project",
	silent = true,
})

-- =========================================================
-- <leader>f group (Find)
-- =========================================================

vim.keymap.set("n", "<leader>ff", function()
	require("telescope.builtin").find_files({
		prompt_title = "Find files",
		cwd = project_root(),
		hidden = true,
	})
end, {
	desc = "Find files in project",
	silent = true,
})

vim.keymap.set("n", "<leader>fg", function()
	require("telescope.builtin").current_buffer_fuzzy_find({
		prompt_title = "Search current file",
		prompt_prefix = "Search: ",
	})
end, {
	desc = "Search text in current file",
	silent = true,
})

vim.keymap.set("n", "<leader>fb", function()
	require("telescope.builtin").buffers({
		prompt_title = "Open buffers",
	})
end, {
	desc = "List open buffers",
	silent = true,
})

vim.keymap.set("n", "<leader>fo", function()
	require("telescope.builtin").oldfiles({
		prompt_title = "Recent files",
	})
end, {
	desc = "List recent files",
	silent = true,
})

vim.keymap.set("n", "<leader>fd", function()
	require("telescope.builtin").diagnostics({
		prompt_title = "Diagnostics",
	})
end, {
	desc = "List diagnostics",
	silent = true,
})

vim.keymap.set("n", "<leader>fs", function()
	require("telescope.builtin").lsp_document_symbols({
		prompt_title = "Document symbols",
	})
end, {
	desc = "List current document symbols",
	silent = true,
})

vim.keymap.set("n", "<leader>fS", function()
	require("telescope.builtin").lsp_dynamic_workspace_symbols({
		prompt_title = "Workspace symbols",
	})
end, {
	desc = "List workspace symbols",
	silent = true,
})

-- =========================================================
-- Terminal
-- =========================================================

vim.keymap.set(
	"t",
	"<C-w>",
	[[<C-\><C-n><C-w>w]],
	opts
)

-- =========================================================
-- BufferLine
-- =========================================================

vim.keymap.set(
	"n",
	"<Tab>",
	"<cmd>BufferLineCycleNext<CR>",
	opts
)

vim.keymap.set(
	"n",
	"<S-Tab>",
	"<cmd>BufferLineCyclePrev<CR>",
	opts
)

-- =========================================================
-- LSP
-- =========================================================

vim.keymap.set(
	"n",
	"K",
	vim.lsp.buf.hover,
	opts
)

vim.keymap.set(
	"n",
	"gd",
	vim.lsp.buf.definition,
	opts
)

vim.keymap.set(
	"n",
	"<leader>ca",
	vim.lsp.buf.code_action,
	opts
)

-- =========================================================
-- Spring Boot
-- =========================================================

vim.keymap.set(
	"n",
	"<leader>ts",
	"<cmd>NewSpringBoot<CR>",
	opts
)

-- =========================================================
-- Visual Mode
-- =========================================================

-- Keep the selection after increasing indentation
vim.keymap.set("v", ">", ">gv", {
	desc = "Indent selection",
})

-- Keep the selection after decreasing indentation
vim.keymap.set("v", "<lt>", "<gv", {
	desc = "Unindent selection",
})

-- =========================================================
-- Select Mode
-- =========================================================

-- Allow gc after selecting with Shift + arrow keys.
-- Ctrl-G converts Select Mode to Visual Mode.
vim.keymap.set(
	"s",
	"gc",
	"<C-G>gc",
	{
		remap = true,
		desc = "Comment selected lines",
	}
)

-- =========================================================
-- Insert Mode
-- =========================================================

-- Ctrl + Backspace
vim.keymap.set(
	"i",
	"<C-BS>",
	"<C-w>",
	{
		desc = "Delete previous word",
	}
)

-- Some terminals send Ctrl+Backspace as Ctrl+H
vim.keymap.set(
	"i",
	"<C-H>",
	"<C-w>",
	{
		desc = "Delete previous word",
	}
)

-- =========================================================
-- Clipboard
-- =========================================================

-- Ctrl + Shift + C
-- Alacritty sends this combination as F14.

-- Visual Mode
vim.keymap.set("x", "<F14>", '"+y', {
	desc = "Copy to system clipboard",
	silent = true,
})

-- Select Mode
-- Used when selecting with Shift + arrow keys.
vim.keymap.set("s", "<F14>", '<C-G>"+y', {
	desc = "Copy to system clipboard",
	silent = true,
})

-- Ctrl + Shift + V
-- Normal Mode
vim.keymap.set("n", "<C-S-v>", '"+p', {
	desc = "Paste from system clipboard",
	silent = true,
})

-- Insert Mode
vim.keymap.set("i", "<C-S-v>", '<C-r>+', {
	desc = "Paste from system clipboard",
	silent = true,
})

-- Visual Mode
vim.keymap.set("x", "<C-S-v>", '"+p', {
	desc = "Paste from system clipboard",
	silent = true,
})

-- Select Mode
vim.keymap.set("s", "<C-S-v>", '<C-G>"+p', {
	desc = "Paste from system clipboard",
	silent = true,
})

-- Terminal
vim.keymap.set("t", "<C-S-v>", function()
	local text = vim.fn.getreg("+")
	local job = vim.b.terminal_job_id

	if job then
		vim.api.nvim_chan_send(job, text)
	end
end, {
	desc = "Paste from system clipboard",
	silent = true,
})

-- =========================================================
-- Select by word without crossing lines
-- =========================================================

local function select_word_right_same_line()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()

	if line == "" then
		return
	end

	local last_col = #line - 1

	-- Already at the end of the line
	if col >= last_col then
		return
	end

	-- Find the next word boundary,
	-- but only on the current line.
	local pos = vim.fn.searchpos(
		[[\<\|\>]],
		"W",
		row
	)

	if pos[1] == row and pos[2] > 0 then
		local target_col = math.min(
			pos[2] - 1,
			last_col
		)

		vim.api.nvim_win_set_cursor(
			0,
			{ row, target_col }
		)
	else
		-- No other word:
		-- stop at the end of the line.
		vim.api.nvim_win_set_cursor(
			0,
			{ row, last_col }
		)
	end
end

local function select_word_left_same_line()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))

	-- Already at the start of the line
	if col <= 0 then
		return
	end

	-- Find the previous word boundary,
	-- but only on the current line.
	local pos = vim.fn.searchpos(
		[[\<\|\>]],
		"bW",
		row
	)

	if pos[1] == row and pos[2] > 0 then
		vim.api.nvim_win_set_cursor(
			0,
			{ row, pos[2] - 1 }
		)
	else
		-- No other word:
		-- stop at the start of the line.
		vim.api.nvim_win_set_cursor(
			0,
			{ row, 0 }
		)
	end
end

-- =========================================================
-- Select / Visual Mode
-- =========================================================

vim.keymap.set(
	{ "s", "x" },
	"<C-S-Right>",
	select_word_right_same_line,
	{
		desc = "Select word right without crossing line",
		silent = true,
	}
)

vim.keymap.set(
	{ "s", "x" },
	"<C-S-Left>",
	select_word_left_same_line,
	{
		desc = "Select word left without crossing line",
		silent = true,
	}
)

-- =========================================================
-- Insert Mode
-- =========================================================

vim.keymap.set(
	"i",
	"<C-S-Right>",
	function()
		-- Exit Insert Mode and enter Select Mode
		vim.cmd("stopinsert")
		vim.cmd("normal! gh")

		select_word_right_same_line()
	end,
	{
		desc = "Select word right without crossing line",
		silent = true,
	}
)

vim.keymap.set(
	"i",
	"<C-S-Left>",
	function()
		-- Exit Insert Mode and enter Select Mode
		vim.cmd("stopinsert")
		vim.cmd("normal! gh")

		select_word_left_same_line()
	end,
	{
		desc = "Select word left without crossing line",
		silent = true,
	}
)

-- =========================================================
-- Formatter
-- =========================================================

vim.keymap.set(
	{ "n", "v" },
	"<leader>cf",
	function()
		require("conform").format({
			async = true,
		})
	end,
	{
		desc = "Format current buffer",
		silent = true,
	}
)
