require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "pyright", "lua_ls", "clangd", "ts_ls", "css_variables", "eslint" },
})

local lspconfig = require("lspconfig")
local servers = { "pyright", "lua_ls", "clangd", "ts_ls", "cmake" }
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({})
end
