local theme_colors = vim.g.kaizen_theme_colors or {}

-- Indent guides are subtle but readable; the block containing the cursor (scope)
-- uses the bar meters' cyan, like the active guide in VS Code.
local indent_color = "#2c2c33"
local scope_color = theme_colors.teal_soft or "#5FBFC0"

-- Reapply colors when the colorscheme is reloaded (it resets the groups).
local hooks = require("ibl.hooks")
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "IblIndent", { fg = indent_color })
  vim.api.nvim_set_hl(0, "IblScope", { fg = scope_color })
end)

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
