local opts = { noremap = true, silent = true }

vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "<leader>ld", function()
    vim.diagnostic.setqflist({ open = true })
end, vim.tbl_extend("force", opts, { desc = "List diagnostics" }))
