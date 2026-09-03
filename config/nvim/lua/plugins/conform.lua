local conform = require("conform")

conform.setup({
  -- =========================================================
  -- Formatters por linguagem
  -- =========================================================

  formatters_by_ft = {
    -- Python
    python = {
      "ruff_format",
    },

    -- Lua
    lua = {
      "stylua",
    },

    -- Go
    go = {
      "gofmt",
    },

    -- JavaScript
    javascript = {
      "prettier",
    },

    javascriptreact = {
      "prettier",
    },

    -- TypeScript
    typescript = {
      "prettier",
    },

    typescriptreact = {
      "prettier",
    },

    -- Web
    html = {
      "prettier",
    },

    css = {
      "prettier",
    },

    scss = {
      "prettier",
    },

    -- JSON
    json = {
      "prettier",
    },

    jsonc = {
      "prettier",
    },

    -- Markdown
    markdown = {
      "prettier",
    },

    -- Nix
    nix = {
      "nixfmt",
    },
  },

  -- Se não houver formatter externo configurado,
  -- utiliza o formatter do LSP.
  --
  -- Isso também atende Java/JDTLS, por exemplo.
  default_format_opts = {
    lsp_format = "fallback",
  },

  -- Formata automaticamente antes de salvar.
  format_on_save = {
    timeout_ms = 1000,
  },

  notify_on_error = true,
  notify_no_formatters = false,
})
