local mason = require("mason")
local mlsp = require("mason-lspconfig")

mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

local function project_python(root_dir)
  local candidates = {}
  if vim.env.VIRTUAL_ENV then
    table.insert(candidates, vim.env.VIRTUAL_ENV .. "/bin/python")
  end
  if root_dir then
    table.insert(candidates, root_dir .. "/.venv/bin/python")
    table.insert(candidates, root_dir .. "/venv/bin/python")
  end

  for _, candidate in ipairs(candidates) do
    if candidate and vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end
end

local server_specific = {
  basedpyright = {
    before_init = function(_, config)
      local python = project_python(config.root_dir)
      if python then
        config.settings.python = config.settings.python or {}
        config.settings.python.pythonPath = python
      end
    end,
    root_dir = function(bufnr, on_dir)
      local fname = vim.api.nvim_buf_get_name(bufnr)
      local markers = require("lspconfig.util").root_pattern(
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        "pyrightconfig.json"
      )(fname)
      on_dir(markers or vim.fs.dirname(fname))
    end,
    settings = {
      basedpyright = {
        analysis = {
          typeCheckingMode = "basic",
          diagnosticSeverityOverrides = {
            reportUnknownParameterType = "none",
            reportMissingParameterType = "none",
          },
          inlayHints = {
            variableTypes = false,
            callArgumentNames = true,
            callArgumentNamesMatching = false,
            functionReturnTypes = false,
            genericTypes = false,
          },
        },
      },
    },
  },
  lua_ls = {
    root_dir = function(bufnr, on_dir)
      local fname = vim.api.nvim_buf_get_name(bufnr)
      local config_root = vim.fn.stdpath("config")
      if fname:find(config_root, 1, true) == 1 then
        on_dir(config_root)
        return
      end

      on_dir(require("lspconfig.util").root_pattern(".luarc.json", ".luarc.jsonc", ".git")(fname))
    end,
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim", "Run" } },
        workspace = {
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
          },
          checkThirdParty = false,
        },
        telemetry = { enable = false },
        hint = {
          enable = true,
          arrayIndex = "Auto",
          await = true,
          paramName = "All",
          paramType = true,
          semicolon = "SameLine",
          setType = false,
        },
      },
    },
  },
  ts_ls = {
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  },
}

local servers = { "basedpyright", "clangd", "lua_ls", "ts_ls" }

for _, server_name in ipairs(servers) do
  local opts = {
    capabilities = capabilities,
  }

  if server_specific[server_name] then
    opts = vim.tbl_deep_extend("force", opts, server_specific[server_name])
  end

  vim.lsp.config(server_name, opts)
end

mlsp.setup({
  ensure_installed = servers,
  automatic_enable = servers,
})

-- =========================================================
-- Ruff (diagnóstico Python)
--
-- Não é um pacote Mason: usa o binário `ruff` instalado pelo
-- gerenciador do sistema, igual aos formatadores externos do
-- conform.nvim. Hover fica só com basedpyright.
-- =========================================================

if vim.fn.executable("ruff") == 1 then
  vim.lsp.config("ruff", {
    capabilities = capabilities,
    on_attach = function(client)
      client.server_capabilities.hoverProvider = false
    end,
  })
  vim.lsp.enable("ruff")
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }

    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
      vim.keymap.set("n", "<leader>lh", function()
        local filter = { bufnr = ev.buf }
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)
      end, vim.tbl_extend("force", opts, {
        desc = "Alternar inlay hints",
      }))
    end

    if client and client.name == "basedpyright" and client:supports_method("textDocument/signatureHelp") then
      local function signature_help()
        vim.lsp.buf.signature_help({
          border = "rounded",
          focusable = false,
        })
      end

      vim.keymap.set("i", "<C-k>", signature_help, vim.tbl_extend("force", opts, {
        desc = "Mostrar assinatura da funcao",
      }))

      if not vim.b[ev.buf].python_signature_help_configured then
        vim.b[ev.buf].python_signature_help_configured = true
        vim.api.nvim_create_autocmd("InsertCharPre", {
          buffer = ev.buf,
          callback = function()
            if vim.v.char == "(" or vim.v.char == "," then
              vim.schedule(signature_help)
            end
          end,
        })
      end
    end

    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<space>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})
