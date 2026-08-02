local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>gg", "<cmd>Git<CR>", vim.tbl_extend("force", opts, {
    desc = "Git status",
}))

vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<CR>", vim.tbl_extend("force", opts, {
    desc = "Git commit",
}))

vim.keymap.set("n", "<leader>gP", "<cmd>Git push<CR>", vim.tbl_extend("force", opts, {
    desc = "Git push",
}))

vim.keymap.set("n", "<leader>gl", "<cmd>Git pull<CR>", vim.tbl_extend("force", opts, {
    desc = "Git pull",
}))
