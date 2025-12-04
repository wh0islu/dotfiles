require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "pyright", "lua_ls", "clangd", "ts_ls" },
})

local function on_attach(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap = true, silent = true }
  buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "K",  "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local function register_server(name, opts)
  opts = opts or {}
  if opts.on_attach == nil then opts.on_attach = on_attach end
  if opts.capabilities == nil then opts.capabilities = capabilities end

  vim.lsp.config(name, opts)

  vim.lsp.enable(name)
end

local servers = { "pyright", "lua_ls", "clangd", "ts_ls", "cmake" }

for _, name in ipairs(servers) do
  if name == "lua_ls" then
    register_server(name, {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
        },
      },
    })
  else
    register_server(name)
  end
end
