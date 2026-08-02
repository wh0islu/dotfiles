local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
    return
end

gitsigns.setup({
    signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "▁" },
        topdelete = { text = "▔" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
    },
    current_line_blame = false,
    on_attach = function(bufnr)
        local opts = { buffer = bufnr, silent = true }

        vim.keymap.set("n", "]h", gitsigns.next_hunk, opts)
        vim.keymap.set("n", "[h", gitsigns.prev_hunk, opts)
        vim.keymap.set("n", "<leader>gs", gitsigns.stage_hunk, opts)
        vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk, opts)
        vim.keymap.set("v", "<leader>gs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, opts)
        vim.keymap.set("v", "<leader>gr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, opts)
        vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk, opts)
        vim.keymap.set("n", "<leader>gb", gitsigns.blame_line, opts)
        vim.keymap.set("n", "<leader>gd", gitsigns.diffthis, opts)
    end,
})
