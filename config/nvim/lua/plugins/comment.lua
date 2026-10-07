require("Comment").setup({
  mappings = false,
})

vim.keymap.set("n", "<leader>/", "<Plug>(comment_toggle_linewise_current)", {
  remap = true,
  desc = "Toggle line comment",
})

vim.keymap.set("x", "<leader>/", "<Plug>(comment_toggle_linewise_visual)", {
  remap = true,
  desc = "Toggle selection comment",
})
