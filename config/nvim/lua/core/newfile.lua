local function find_editor_window()
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local buf = vim.api.nvim_win_get_buf(win)

		if vim.bo[buf].filetype ~= "NvimTree" and vim.bo[buf].buftype == "" then
			return win
		end
	end

	return nil
end

local function open_created_file(path)
	if vim.bo.filetype == "NvimTree" then
		local win = find_editor_window()

		if win then
			vim.api.nvim_set_current_win(win)
		else
			vim.cmd("vsplit")
		end
	end

	vim.cmd("edit " .. vim.fn.fnameescape(path))
end

local function nvimtree_target_dir()
	local ok, api = pcall(require, "nvim-tree.api")
	if not ok then
		return nil
	end

	local node = api.tree.get_node_under_cursor()
	if not node then
		return nil
	end

	if node.type == "directory" then
		return node.absolute_path
	end

	if node.absolute_path then
		return vim.fs.dirname(node.absolute_path)
	end

	return nil
end

local function target_dir()
	if vim.bo.filetype == "NvimTree" then
		local dir = nvimtree_target_dir()
		if dir then
			return dir
		end
	end

	local bufname = vim.api.nvim_buf_get_name(0)
	if bufname ~= "" then
		return vim.fs.dirname(bufname)
	end

	return vim.fn.getcwd()
end

local function create_file()
	local dir = target_dir()

	vim.ui.input({
		prompt = "Novo arquivo em " .. vim.fn.fnamemodify(dir, ":~") .. "/: ",
	}, function(name)
		if not name or name == "" then
			return
		end

		local path = dir .. "/" .. name

		if vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1 then
			vim.notify("Ja existe: " .. path, vim.log.levels.WARN)
			return
		end

		vim.fn.mkdir(vim.fs.dirname(path), "p")
		vim.fn.writefile({}, path)

		pcall(function()
			require("nvim-tree.api").tree.reload()
		end)

		open_created_file(path)

		vim.notify("Arquivo criado: " .. path, vim.log.levels.INFO)
	end)
end


vim.api.nvim_create_user_command("NewFile", create_file, {
	desc = "Cria um arquivo na pasta atual",
	force = true,
})

vim.keymap.set("n", "<leader>ee", create_file, {
	desc = "Criar arquivo na pasta atual",
	silent = true,
})
