local theme_colors = vim.g.kaizen_theme_colors or {}

vim.api.nvim_set_hl(0, "IblIndent", { fg = theme_colors.border or "#131313" })
vim.api.nvim_set_hl(0, "IblScope", { fg = theme_colors.muted_soft or "#343434" })

require("ibl").setup({
  indent = {
    char = "│",
    highlight = "IblIndent",
  },

  scope = {
    enabled = true,
    highlight = "IblScope",
    show_start = false,
    show_end = false,
  },

  exclude = {
    filetypes = {
      "NvimTree",
      "kaizen_dashboard",
      "lazy",
      "mason",
      "help",
      "toggleterm",
    },
  },
})
