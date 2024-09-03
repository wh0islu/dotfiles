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
