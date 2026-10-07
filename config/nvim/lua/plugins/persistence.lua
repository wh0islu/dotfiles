local ok, persistence = pcall(require, "persistence")
if not ok then
    return
end

persistence.setup({
    dir = vim.fn.stdpath("state") .. "/sessions/",
    options = { "buffers", "curdir", "tabpages", "winsize" },
})

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>qs", function()
    persistence.load()
end, vim.tbl_extend("force", opts, { desc = "Restore session" }))

vim.keymap.set("n", "<leader>ql", function()
    persistence.load({ last = true })
end, vim.tbl_extend("force", opts, { desc = "Restore last session" }))

vim.keymap.set("n", "<leader>qd", function()
    persistence.stop()
end, vim.tbl_extend("force", opts, { desc = "Stop saving the session" }))
