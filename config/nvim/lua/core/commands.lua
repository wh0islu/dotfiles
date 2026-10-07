local function format_buffer()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
        vim.notify("No active LSP client to format this buffer.", vim.log.levels.WARN)
        return
    end

    vim.lsp.buf.format({
        async = false,
        timeout_ms = 3000,
    })
end

local function lint_buffer()
    local diagnostics = vim.diagnostic.get(0)
    if #diagnostics == 0 then
        vim.notify("No diagnostics found in the current buffer.", vim.log.levels.INFO)
        return
    end

    vim.fn.setqflist({}, " ", {
        title = "Diagnostics",
        items = vim.diagnostic.toqflist(diagnostics),
    })
    vim.cmd("copen")
end

local function reload_config()
    local modules = {
        "^core%.",
        "^plugins%.",
        "^themes%.",
    }

    for name in pairs(package.loaded) do
        for _, pattern in ipairs(modules) do
            if name:match(pattern) then
                package.loaded[name] = nil
                break
            end
        end
    end

    dofile(vim.env.MYVIMRC)
    vim.notify("Neovim configuration reloaded.", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("Format", format_buffer, {
    desc = "Format the current buffer using LSP",
    force = true,
})

vim.api.nvim_create_user_command("Lint", lint_buffer, {
    desc = "Open current buffer diagnostics in quickfix",
    force = true,
})

vim.api.nvim_create_user_command("ReloadConfig", reload_config, {
    desc = "Reload the local Neovim configuration",
    force = true,
})
