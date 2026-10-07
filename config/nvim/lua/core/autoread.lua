-- Reload buffers when files change outside Neovim (e.g. edits by Claude Code).
-- autoread alone only runs at certain times; checktime below performs the checks.
vim.o.autoread = true

local group = vim.api.nvim_create_augroup("UserAutoRead", { clear = true })

vim.api.nvim_create_autocmd({
    "FocusGained",
    "BufEnter",
    "CursorHold",
    "CursorHoldI",
    "TermLeave",
}, {
    group = group,
    callback = function()
        -- Real files only: terminals and plugin buffers have nothing to reload.
        if vim.bo.buftype ~= "" or vim.api.nvim_buf_get_name(0) == "" then
            return
        end
        pcall(vim.cmd, "checktime")
    end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
    group = group,
    callback = function()
        vim.notify("File reloaded: changed outside Neovim.", vim.log.levels.INFO)
    end,
})
