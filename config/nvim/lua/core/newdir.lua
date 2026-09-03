local function reveal_created_dir(path)
	pcall(function()
		require("nvim-tree.api").tree.reload()
	end)

	pcall(function()
		require("nvim-tree.api").tree.find_file({
			buf = path,
			open = true,
			focus = true,
		})
	end)
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

local function create_dir()
	local dir = target_dir()

	vim.ui.input({
		prompt = "Nova pasta em " .. vim.fn.fnamemodify(dir, ":~") .. "/: ",
	}, function(name)
		if not name or name == "" then
			return
		end

		local path = dir .. "/" .. name

		if vim.fn.isdirectory(path) == 1 or vim.fn.filereadable(path) == 1 then
			vim.notify("Ja existe: " .. path, vim.log.levels.WARN)
			return
		end

		if vim.fn.mkdir(path, "p") == 0 then
			vim.notify("Nao foi possivel criar: " .. path, vim.log.levels.ERROR)
			return
		end

		reveal_created_dir(path)

		vim.notify("Pasta criada: " .. path, vim.log.levels.INFO)
	end)
end

vim.api.nvim_create_user_command("NewDir", create_dir, {
	desc = "Cria uma pasta na pasta atual",
	force = true,
})

vim.keymap.set("n", "<leader>ed", create_dir, {
	desc = "Criar pasta na pasta atual",
	silent = true,
})
