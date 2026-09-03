local opts = {
    noremap = true,
    silent = true,
}

-- =========================================================
-- Estilo dos diagnostics
-- =========================================================

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
    },

    virtual_text = {
        spacing = 1,
        prefix = "·",
        source = false,
        severity = {
            min = vim.diagnostic.severity.WARN,
        },
    },

    underline = true,
    update_in_insert = false,
    severity_sort = true,

    float = {
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
    },
})

-- =========================================================
-- Navegação entre diagnostics
-- =========================================================

-- Próximo diagnostic
vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({
        count = 1,
        float = true,
    })
end, vim.tbl_extend("force", opts, {
    desc = "Next diagnostic",
}))

-- Diagnostic anterior
vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({
        count = -1,
        float = true,
    })
end, vim.tbl_extend("force", opts, {
    desc = "Previous diagnostic",
}))

-- =========================================================
-- Lista de diagnostics
-- =========================================================

vim.keymap.set("n", "<leader>ld", function()
    vim.diagnostic.setqflist({
        open = true,
    })
end, vim.tbl_extend("force", opts, {
    desc = "List diagnostics",
}))

-- =========================================================
-- Diagnostic automático ao parar o cursor
-- =========================================================

local diagnostic_group = vim.api.nvim_create_augroup(
    "KaizenDiagnosticFloat",
    {
        clear = true,
    }
)

local hover_close_events = {
    "CursorMoved",
    "CursorMovedI",
    "BufHidden",
    "InsertCharPre",
}

vim.api.nvim_create_autocmd("CursorHold", {
    group = diagnostic_group,

    callback = function()
        local cursor = vim.api.nvim_win_get_cursor(0)

        local diagnostics = vim.diagnostic.get(
            0,
            {
                lnum = cursor[1] - 1,
            }
        )

        if #diagnostics > 0 then
            vim.diagnostic.open_float(nil, {
                scope = "cursor",

                focus = false,
                focusable = false,

                border = "rounded",

                source = "if_many",

                header = "",

                prefix = "",

                close_events = hover_close_events,
            })
        end
    end,
})
