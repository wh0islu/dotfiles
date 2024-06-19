vim.g.loaded_netw=0
vim.g.loaded_netrwPlugin=0
vim.o.termguicolors=true
require("nvim-tree").setup()
require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
	adaptive_size = true,

    },
    renderer = {
	group_empy = true,

    },
    filters = {
	dotfiles = true,

    },
})
