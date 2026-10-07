-- Bulk replacement using Telescope's quickfix list.
--
-- Workflow: search the current file with <leader>fg, send results
-- to quickfix with <C-q> (or select several with <Tab> and <C-q>),
-- then use <leader>fr to fill in and run :cfdo.

local function quickfix_substitute()
	if vim.fn.getqflist({ size = 0 }).size == 0 then
		vim.notify(
			"Quickfix list is empty. Search with <leader>fg and send results with <C-q> first.",
			vim.log.levels.WARN
		)
		return
	end

	vim.ui.input({ prompt = "Search: " }, function(search)
		if not search or search == "" then
			return
		end

		vim.ui.input({ prompt = "Replace with: " }, function(replace)
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

			vim.notify("Replacement applied to the quickfix files.", vim.log.levels.INFO)
		end)
	end)
end

vim.keymap.set("n", "<leader>fr", quickfix_substitute, {
	desc = "Replace in quickfix files",
	silent = true,
})
