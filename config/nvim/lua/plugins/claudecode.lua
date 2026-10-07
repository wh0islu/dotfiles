local ok, claudecode = pcall(require, "claudecode")
if not ok then
    return
end

claudecode.setup({})

vim.keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<cr>", {
    desc = "Toggle Claude",
    noremap = true,
    silent = true,
})

vim.keymap.set("v", "<leader>cs", "<cmd>ClaudeCodeSend<cr>", {
    desc = "Send selection to Claude",
    noremap = true,
    silent = true,
})

vim.keymap.set("n", "<leader>cw", "<cmd>ClaudeCodeFocus<cr>", {
    desc = "Focus Claude window",
    noremap = true,
    silent = true,
})
