return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup {
            }
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            require("mason-lspconfig").setup {
                ensure_installed = {
                    "pyright",
                    "ruff",
                    "clangd",
                    "ts_ls",
                    "lua_ls",
                },
                automatic_installation = true,
            }
        end,
    },
}
