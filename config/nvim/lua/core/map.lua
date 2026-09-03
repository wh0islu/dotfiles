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
-- Arquivos
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
	desc = "Abrir File Explorer",
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
-- Buscar no arquivo atual
-- =========================================================

vim.keymap.set("n", "<C-f>", function()
	local buftype = vim.bo.buftype
	local filetype = vim.bo.filetype

	-- Evita pesquisar buffers especiais.
	if buftype ~= "" then
		vim.notify(
			"Ctrl+F está disponível somente em arquivos.",
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
		prompt_title = "Buscar no arquivo",
	})
end, {
	desc = "Buscar no arquivo atual",
	silent = true,
})

-- =========================================================
-- Ctrl + Shift + F
-- Alacritty envia como F13
-- Buscar conteúdo no projeto inteiro
-- =========================================================

vim.keymap.set("n", "<F13>", function()
	require("telescope.builtin").live_grep({
		prompt_title = "Buscar no projeto",
		cwd = project_root(),
	})
end, {
	desc = "Buscar texto no projeto",
	silent = true,
})

-- =========================================================
-- Ctrl + P
-- Buscar arquivos pelo nome
-- =========================================================

vim.keymap.set("n", "<C-p>", function()
	require("telescope.builtin").find_files({
		prompt_title = "Buscar arquivos",
		cwd = project_root(),
		hidden = true,
	})
end, {
	desc = "Buscar arquivos no projeto",
	silent = true,
})

-- =========================================================
-- Grupo <leader>f (Find)
-- =========================================================

vim.keymap.set("n", "<leader>ff", function()
	require("telescope.builtin").find_files({
		prompt_title = "Buscar arquivos",
		cwd = project_root(),
		hidden = true,
	})
end, {
	desc = "Buscar arquivos no projeto",
	silent = true,
})

vim.keymap.set("n", "<leader>fg", function()
	require("telescope.builtin").current_buffer_fuzzy_find({
		prompt_title = "Buscar no arquivo atual",
		prompt_prefix = "Buscar: ",
	})
end, {
	desc = "Buscar texto no arquivo atual",
	silent = true,
})

vim.keymap.set("n", "<leader>fb", function()
	require("telescope.builtin").buffers({
		prompt_title = "Buffers abertos",
	})
end, {
	desc = "Listar buffers abertos",
	silent = true,
})

vim.keymap.set("n", "<leader>fo", function()
	require("telescope.builtin").oldfiles({
		prompt_title = "Arquivos recentes",
	})
end, {
	desc = "Listar arquivos recentes",
	silent = true,
})

vim.keymap.set("n", "<leader>fd", function()
	require("telescope.builtin").diagnostics({
		prompt_title = "Diagnostics",
	})
end, {
	desc = "Listar diagnostics",
	silent = true,
})

vim.keymap.set("n", "<leader>fs", function()
	require("telescope.builtin").lsp_document_symbols({
		prompt_title = "Symbols do arquivo",
	})
end, {
	desc = "Listar symbols do arquivo atual",
	silent = true,
})

vim.keymap.set("n", "<leader>fS", function()
	require("telescope.builtin").lsp_dynamic_workspace_symbols({
		prompt_title = "Symbols do workspace",
	})
end, {
	desc = "Listar symbols do workspace",
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

-- Mantém a seleção após aumentar indentação
vim.keymap.set("v", ">", ">gv", {
	desc = "Indent selection",
})

-- Mantém a seleção após diminuir indentação
vim.keymap.set("v", "<lt>", "<gv", {
	desc = "Unindent selection",
})

-- =========================================================
-- Select Mode
-- =========================================================

-- Permite usar gc depois de selecionar com Shift + setas.
-- Ctrl-G converte Select Mode para Visual Mode.
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

-- Alguns terminais enviam Ctrl+Backspace como Ctrl+H
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
-- O Alacritty envia essa combinação como F14.

-- Visual Mode
vim.keymap.set("x", "<F14>", '"+y', {
	desc = "Copy to system clipboard",
	silent = true,
})

-- Select Mode
-- Usado quando você seleciona com Shift + setas.
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
-- Seleção por palavra sem cruzar linhas
-- =========================================================

local function select_word_right_same_line()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()

	if line == "" then
		return
	end

	local last_col = #line - 1

	-- Já chegou ao final da linha
	if col >= last_col then
		return
	end

	-- Procura o próximo limite de palavra,
	-- mas somente na linha atual.
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
		-- Não há outra palavra:
		-- para no final da linha.
		vim.api.nvim_win_set_cursor(
			0,
			{ row, last_col }
		)
	end
end

local function select_word_left_same_line()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))

	-- Já chegou ao início da linha
	if col <= 0 then
		return
	end

	-- Procura o limite anterior de palavra,
	-- mas somente na linha atual.
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
		-- Não há outra palavra:
		-- para no início da linha.
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
		-- Sai do Insert Mode e inicia Select Mode
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
		-- Sai do Insert Mode e inicia Select Mode
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
