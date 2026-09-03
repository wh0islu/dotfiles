local ok, claudecode = pcall(require, "claudecode")
if not ok then
    return
end

claudecode.setup({})

vim.keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<cr>", {
    desc = "Abrir/fechar Claude",
    noremap = true,
    silent = true,
})

vim.keymap.set("v", "<leader>cs", "<cmd>ClaudeCodeSend<cr>", {
    desc = "Enviar selecao para o Claude",
    noremap = true,
    silent = true,
})

vim.keymap.set("n", "<leader>cw", "<cmd>ClaudeCodeFocus<cr>", {
    desc = "Focar janela do Claude",
    noremap = true,
    silent = true,
})
