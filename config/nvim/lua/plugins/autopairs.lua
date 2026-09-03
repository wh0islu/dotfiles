require("nvim-autopairs").setup({
  check_ts = true,
})

-- Integra com o nvim-cmp: aceitar uma funcao do completion
-- ja fecha os parenteses automaticamente.
--
-- Agendado com vim.schedule para nao depender da ordem de
-- carregamento entre nvim-autopairs e nvim-cmp (os dois
-- entram no InsertEnter).
vim.schedule(function()
  local ok_cmp, cmp = pcall(require, "cmp")
  local ok_pairs, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")

  if ok_cmp and ok_pairs then
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end
end)
