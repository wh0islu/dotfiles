vim.g.mapleader = ","
<<<<<<< HEAD
vim.cmd([[nnoremap <C-r> :lua Run()<CR>]])
vim.cmd([[nnoremap <C-s> :w!<CR>]])
vim.cmd([[nnoremap <C-q> :q<CR>]])
vim.cmd([[nnoremap <C-x> :x<CR>]])
vim.cmd([[nnoremap <leader>g gg]])
vim.cmd([[nnoremap <C-n> :NvimTreeToggle<CR>]])
vim.cmd([[nnoremap <C-t> :ToggleTerm<CR>]])
vim.cmd([[nnoremap <C-f> :Telescope<CR>]])
vim.api.nvim_set_keymap('n', '<leader>f', '<cmd>Telescope find_files<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-w>', [[<C-\><C-n><C-w>w]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-w>', [[<C-w>w]], { noremap = true, silent = true })
vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { noremap = true, silent = true })
=======

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
>>>>>>> 686dc5b250e2caddb086ff55b7447e33eac44f13
