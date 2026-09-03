-- Substituicao em massa usando a quickfix list do proprio Telescope.
--
-- Fluxo: busque no arquivo atual com <leader>fg, mande os resultados
-- pra quickfix com <C-q> (ou selecione varios com <Tab> e <C-q>),
-- depois use <leader>fr para preencher e rodar o :cfdo.

local function quickfix_substitute()
	if vim.fn.getqflist({ size = 0 }).size == 0 then
		vim.notify(
			"Quickfix list vazia. Busque com <leader>fg e mande os resultados com <C-q> antes.",
			vim.log.levels.WARN
		)
		return
	end

	vim.ui.input({ prompt = "Buscar: " }, function(search)
		if not search or search == "" then
			return
		end

		vim.ui.input({ prompt = "Substituir por: " }, function(replace)
			if replace == nil then
				return
			end

			local pattern = "\\V" .. vim.fn.escape(search, "/\\")
			local substitution = vim.fn.escape(replace, "/\\&~")

			vim.cmd(
				string.format(
					"cfdo %%s/%s/%s/ge | update",
					pattern,
					substitution
				)
			)

			vim.notify("Substituicao aplicada nos arquivos do quickfix.", vim.log.levels.INFO)
		end)
	end)
end

vim.keymap.set("n", "<leader>fr", quickfix_substitute, {
	desc = "Substituir nos arquivos da quickfix list",
	silent = true,
})
