local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
    { "nvim-telescope/telescope.nvim", tag = "0.1.6", dependencies = { "nvim-lua/plenary.nvim" } },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "nvim-tree/nvim-tree.lua" },
    { "akinsho/toggleterm.nvim", version = "*" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim", dependencies = { "neovim/nvim-lspconfig" } },
    { "neovim/nvim-lspconfig" },
    { "tpope/vim-fugitive" },
    { "preservim/vim-markdown", ft = "markdown" },
    { "numToStr/Comment.nvim" },
    {'norcalli/nvim-colorizer.lua'},
    {'akinsho/bufferline.nvim', version = "*", dependencies = { 'nvim-tree/nvim-web-devicons' },},
})
