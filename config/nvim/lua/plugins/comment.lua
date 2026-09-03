require("Comment").setup({
  mappings = false,
})

vim.keymap.set("n", "<leader>/", "<Plug>(comment_toggle_linewise_current)", {
  remap = true,
  desc = "Alternar comentario da linha",
})

vim.keymap.set("x", "<leader>/", "<Plug>(comment_toggle_linewise_visual)", {
  remap = true,
  desc = "Alternar comentario da selecao",
})
