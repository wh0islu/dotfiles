local ok, todo = pcall(require, "todo-comments")
if not ok then
    return
end

todo.setup({
    signs = true,
    keywords = {
        TODO = { icon = " ", color = "info" },
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG" } },
        HACK = { icon = " ", color = "warning" },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        WARN = { icon = " ", color = "warning", alt = { "WARNING" } },
    },
})

vim.keymap.set("n", "<leader>td", "<cmd>TodoTelescope<CR>", {
    desc = "Buscar TODOs",
    noremap = true,
    silent = true,
})
