require("nvim-autopairs").setup({
  check_ts = true,
})

-- Integrate with nvim-cmp: accepting a function from completion
-- automatically closes the parentheses.
--
-- Schedule with vim.schedule to avoid depending on the loading order
-- of nvim-autopairs and nvim-cmp (both load
-- on InsertEnter).
vim.schedule(function()
  local ok_cmp, cmp = pcall(require, "cmp")
  local ok_pairs, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")

  if ok_cmp and ok_pairs then
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end
end)
