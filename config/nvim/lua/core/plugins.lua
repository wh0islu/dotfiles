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

if vim.g.kaizen_lazy_loaded then
    return
end

vim.g.kaizen_lazy_loaded = true

require("lazy").setup({
<<<<<<< HEAD
    { "nvim-tree/nvim-web-devicons", lazy = false, config = true },
    { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
    { "akinsho/bufferline.nvim", version = "*", dependencies = { 'nvim-tree/nvim-web-devicons' } },
    { "catgoose/nvim-colorizer.lua" },
    { "numToStr/Comment.nvim" },
=======
    {
      "nvim-lualine/lualine.nvim",
      event = "VeryLazy",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("plugins.lualine")
      end,
    },
    {
      "akinsho/bufferline.nvim",
      version = "*",
      event = "VeryLazy",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("plugins.bufferline")
      end,
    },
    {
      "NvChad/nvim-colorizer.lua",
      event = { "BufReadPost", "BufNewFile" },
      config = function()
        require("plugins.colorizer")
      end,
    },
    {
      "numToStr/Comment.nvim",
      event = "VeryLazy",
      config = function()
        require("plugins.comment")
      end,
    },
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      cmd = "WhichKey",
      config = function()
        require("plugins.which_key")
      end,
    },
    {
      "lewis6991/gitsigns.nvim",
      event = { "BufReadPre", "BufNewFile" },
      cmd = "Gitsigns",
      config = function()
        require("plugins.gitsigns")
      end,
    },
    {
      "folke/todo-comments.nvim",
      event = { "BufReadPost", "BufNewFile" },
      cmd = { "TodoTelescope", "TodoQuickFix", "TodoLocList", "TodoTrouble" },
      keys = { "<leader>td" },
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("plugins.todo_comments")
      end,
    },
    {
      "folke/persistence.nvim",
      event = "BufReadPre",
      keys = { "<leader>qs", "<leader>ql", "<leader>qd" },
      config = function()
        require("plugins.persistence")
      end,
    },
>>>>>>> 686dc5b250e2caddb086ff55b7447e33eac44f13

    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.6",
      cmd = "Telescope",
      keys = { "<leader>ff", "<leader>fg", "<leader>fb", "<leader>fo", "<leader>fd", "<leader>fs", "<leader>fS" },
      dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
      config = function()
        require("plugins.telescope")
      end,
    },
    { "nvim-telescope/telescope-ui-select.nvim", lazy = true },

<<<<<<< HEAD
    { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
=======
    {
      "nvim-tree/nvim-tree.lua",
      cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus" },
      config = function()
        require("plugins.ntree")
      end,
    },
>>>>>>> 686dc5b250e2caddb086ff55b7447e33eac44f13

    {
      "akinsho/toggleterm.nvim",
      version = "*",
      cmd = { "ToggleTerm", "TermExec" },
      keys = { "<C-t>", "<leader>ai", "<leader>ac", "<leader>ak", "<leader>ar", "<leader>tr", "<leader>tn", "<leader>tg", "<leader>gt" },
      config = function()
        require("plugins.toggleterm")
      end,
    },

    {
      "tpope/vim-fugitive",
      cmd = { "Git", "G" },
      keys = { "<leader>gg", "<leader>gc", "<leader>gP", "<leader>gl" },
      config = function()
        require("plugins.fugitive")
      end,
    },

    { "williamboman/mason.nvim", cmd = "Mason" },
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      event = { "BufReadPre", "BufNewFile" },
      cmd = {
        "MasonToolsInstall",
        "MasonToolsInstallSync",
        "MasonToolsUpdate",
        "MasonToolsUpdateSync",
        "MasonToolsClean",
      },
      dependencies = { "williamboman/mason.nvim" },
      config = function()
        require("mason-tool-installer").setup({
          ensure_installed = {
            "jdtls",
            "java-debug-adapter",
            "java-test",
          },
          auto_update = false,
          run_on_start = true,
          start_delay = 3000,
        })
      end,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
      config = function()
        require("plugins.mason")
      end,
    },
    { "neovim/nvim-lspconfig", lazy = true },

    {
      "mfussenegger/nvim-jdtls",
      ft = "java",
      dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
      config = function()
        require("plugins.java")
      end,
    },

    { "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
      },
      config = function()
        require("plugins.cmp")
      end,
    },

    { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp", lazy = true },
    { "saadparwaiz1/cmp_luasnip", lazy = true },
    { "rafamadriz/friendly-snippets", lazy = true },

    {
      "nvim-treesitter/nvim-treesitter",
<<<<<<< HEAD
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

=======
      branch = "master",
      build = ":TSUpdate",
      event = { "BufReadPost", "BufNewFile" },
      config = function()
        require("nvim-treesitter.configs").setup({
          highlight = {
            enable = true,
            disable = { "markdown", "markdown_inline" },
            additional_vim_regex_highlighting = false,
          },
          ensure_installed = { "lua", "python", "javascript", "typescript", "c", "java" },
        })
      end,
    },

    {
	"mfussenegger/nvim-dap",
        keys = { "<F5>", "<F10>", "<F11>", "<F12>", "<leader>b", "<leader>B" },
	config = function()
	   require("plugins.nvim_dap")
	end,
    },
    {
	"nvim-neotest/nvim-nio",
        lazy = true,
    },

    {
		"rcarriga/nvim-dap-ui",
                keys = { "<F5>", "<F10>", "<F11>", "<F12>" },
		dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
		config = function()
	   local dap, dapui = require("dap"), require("dapui")
	   dapui.setup()
	   dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	   end
	   dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
	   end
	   dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
	   end
	end
    }
}, {
    rocks = {
      enabled = false,
    },
>>>>>>> 686dc5b250e2caddb086ff55b7447e33eac44f13
})
