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
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("plugins.indent_blankline")
	end,
    },
    {
	"numToStr/Comment.nvim",
	event = "VeryLazy",
	keys = { "<leader>/" },
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

    {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	cmd = "Telescope",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
	config = function()
		require("plugins.telescope")
	end,
    },
    {
	"nvim-telescope/telescope-ui-select.nvim", lazy = true },
	{
	    "nvim-tree/nvim-tree.lua",
	    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus" },
	    config = function()
		    require("plugins.ntree")
	    end,
	},
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
	{
	    "williamboman/mason.nvim",
	    cmd = "Mason" },
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
	{
	    "neovim/nvim-lspconfig",
	    lazy = true },
	{
	    "mfussenegger/nvim-jdtls",
	    ft = "java",

	    dependencies = {
		"williamboman/mason.nvim",
	    },

	    config = function()
		require("plugins.java")
	    end,
	},
	{
	    "hrsh7th/nvim-cmp",
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
	{
	    "L3MON4D3/LuaSnip",
	    version = "v2.*",
	    build = "make install_jsregexp",
	    lazy = true
	},
	{
	    "saadparwaiz1/cmp_luasnip",
	    lazy = true
	},
	{
	    "rafamadriz/friendly-snippets",
	    lazy = true 
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("plugins.autopairs")
		end,
	},

	{
	    "nvim-treesitter/nvim-treesitter",
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
	"coder/claudecode.nvim",
	    dependencies = { "folke/snacks.nvim" },
	    cmd = {
		"ClaudeCode",
		"ClaudeCodeFocus",
		"ClaudeCodeSend",
		"ClaudeCodeAdd",
		"ClaudeCodeSelectModel",
	    },
	    keys = { "<leader>cc", "<leader>cw", { "<leader>cs", mode = "v" } },
	    config = function()
		require("plugins.claudecode")
	    end,
	},
	{
	    "stevearc/conform.nvim",
	    event = {
		"BufReadPre",
		"BufNewFile",
	    },

	    cmd = {
		"ConformInfo",
	    },
	    config = function()
		require("plugins.conform")
	    end,
	},
    },
    {
	rocks = {
	    enabled = false,
	},
    })
