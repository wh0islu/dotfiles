vim.g.mapleader = ","

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<C-r>", function()
    Run()
end, opts)
vim.keymap.set("n", "<C-s>", "<cmd>w!<CR>", opts)
vim.keymap.set("n", "<C-q>", "<cmd>q<CR>", opts)
vim.keymap.set("n", "<C-x>", "<cmd>x<CR>", opts)
vim.keymap.set("n", "<C-n>", function()
    pcall(function()
        require("lazy").load({ plugins = { "nvim-tree.lua" } })
    end)

    require("nvim-tree.api").tree.toggle({
        focus = true,
        find_file = true,
    })
end, opts)
vim.keymap.set("n", "<C-f>", "<cmd>Telescope<CR>", opts)
vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>w]], opts)
vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", opts)
vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
vim.keymap.set("n", "<leader>ts", "<cmd>NewSpringBoot<CR>", opts)
