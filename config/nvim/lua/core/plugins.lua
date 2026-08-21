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
    { "nvim-tree/nvim-web-devicons", lazy = false, config = true },
    { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
    { "akinsho/bufferline.nvim", version = "*", dependencies = { 'nvim-tree/nvim-web-devicons' } },
    { "catgoose/nvim-colorizer.lua" },
    { "numToStr/Comment.nvim" },

    { "nvim-telescope/telescope.nvim", tag = "0.1.6", dependencies = { "nvim-lua/plenary.nvim" } },
    { "nvim-telescope/telescope-ui-select.nvim" },

    { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

    { "akinsho/toggleterm.nvim", version = "*" },

    { "tpope/vim-fugitive" },

    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim", dependencies = { "neovim/nvim-lspconfig" } },
    { "neovim/nvim-lspconfig" },

    { "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
      }
    },

    { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
    { "saadparwaiz1/cmp_luasnip" },
    { "rafamadriz/friendly-snippets" },

    {
      "nvim-treesitter/nvim-treesitter",
      branch = "main",
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter").setup({})

        vim.api.nvim_create_autocmd("FileType", {
          pattern = "*",
          callback = function()
            pcall(vim.treesitter.start)
          end,
        })

        local has_parser_compiler = vim.fn.executable("tree-sitter") == 1
          and (vim.fn.executable("cc") == 1
            or vim.fn.executable("gcc") == 1
            or vim.fn.executable("clang") == 1
            or vim.fn.executable("cl") == 1
            or vim.fn.executable("zig") == 1)

        if has_parser_compiler then
          require("nvim-treesitter").install({ "latex" })
        end
      end,
    },

})
