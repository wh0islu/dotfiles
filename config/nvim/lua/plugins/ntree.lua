require("nvim-tree").setup({
  view = {
    width = 30,
    side = "left",
    signcolumn = "no",
  },

  renderer = {
    highlight_opened_files = "none",
    root_folder_label = function(path)
      return vim.fn.fnamemodify(
        path,
        ":t"
      )
    end,
  },

  actions = {
    open_file = {
      window_picker = {
        enable = false,
      },
    },
  },

  hijack_directories = {
    enable = false,
  },

  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
})

-- =========================================================
-- Esconde o cursor de texto dentro do NvimTree
--
-- A linha atual ja fica marcada pelo highlight
-- NvimTreeCursorLine; o bloco do cursor "sumir" evita
-- distracao numa arvore de arquivos.
-- =========================================================

local function nvimtree_cursor_colors()
  local theme_colors = vim.g.kaizen_theme_colors or {}
  local panel = theme_colors.bg_panel or "#0D0D0D"

  return {
    visible = { fg = theme_colors.bg or "#080808", bg = theme_colors.fg_soft or "#C8C8C8" },
    hidden = { fg = panel, bg = panel },
  }
end

local ntree_cursor_group = vim.api.nvim_create_augroup("KaizenNvimTreeCursor", { clear = true })

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = ntree_cursor_group,
  callback = function()
    if vim.bo.filetype == "NvimTree" then
      local hidden = nvimtree_cursor_colors().hidden
      vim.api.nvim_set_hl(0, "Cursor", hidden)
      vim.api.nvim_set_hl(0, "lCursor", hidden)
    end
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  group = ntree_cursor_group,
  callback = function()
    if vim.bo.filetype == "NvimTree" then
      local visible = nvimtree_cursor_colors().visible
      vim.api.nvim_set_hl(0, "Cursor", visible)
      vim.api.nvim_set_hl(0, "lCursor", visible)
    end
  end,
})
