local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Lazy setup
require("lazy").setup({
    {
	"nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }
    },
    {
	"nvim-telescope/telescope.nvim", tag = "0.1.6", dependencies = { "nvim-lua/plenary.nvim" }
    },
    {
	"nvim-tree/nvim-tree.lua",
    },
    {
      'akinsho/toggleterm.nvim', version = "*", config = true
    },
})


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Lazy setup
require("lazy").setup({
    {
	"nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }
    },
    {
	"nvim-telescope/telescope.nvim", tag = "0.1.6", dependencies = { "nvim-lua/plenary.nvim" }
    },
    {
	"nvim-tree/nvim-tree.lua",
    },
    {
      'akinsho/toggleterm.nvim', version = "*", config = true
    },
})](<local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Lazy setup
require("lazy").setup({
    {
	"nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }
    },
    {
	"nvim-telescope/telescope.nvim", tag = "0.1.6", dependencies = { "nvim-lua/plenary.nvim" }
    },
    {
	"nvim-tree/nvim-tree.lua",
    },
    {
      'akinsho/toggleterm.nvim', version = "*", config = true
    },
})


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Lazy setup
require("lazy").setup({
    {
	"nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }
    },
    {
	"nvim-telescope/telescope.nvim", tag = "0.1.6", dependencies = { "nvim-lua/plenary.nvim" }
    },
    {
	"nvim-tree/nvim-tree.lua",
    },
    {
      'akinsho/toggleterm.nvim', version = "*", config = true
    },
})>)](<local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- Opte por usar a versão estável
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" }
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.6",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    {
	"nvim-telescope/telescope-ui-select.nvim",
	config = function()
	    require("telescope").setup({
		extensions = {
		    ["ui-select"] = {
			require("telescope.themes").get_dropdown{
			}
		    }
		}
	    })
	    require("telescope").load_extension("ui-select")
	end
    },
    {
        "nvim-tree/nvim-tree.lua",
    },
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = true
    },
    {
        "williamboman/mason.nvim",
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "pyright", "tsserver", "lua_ls" },
            })
            local lspconfig = require("lspconfig")
            local servers = { "pyright", "lua_ls", "cmake" }

            for _, lsp in ipairs(servers) do
                lspconfig[lsp].setup({})
            end
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({})
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
            vim.keymap.set('n', '%3Cleader%3Eca', vim.lsp.buf.code_action, {noremap = true, silent = true})
        end
    },
    {
	"tpope/vim-fugitive",
    },
    {
        'preservim/vim-markdown',
        ft = 'markdown',
        config = function()
	    vim.g.vim_markdown_folding_disabled = 1
            vim.g.vim_markdown_conceal = 0
            vim.g.vim_markdown_frontmatter = 1
	end
    },
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    },
})
