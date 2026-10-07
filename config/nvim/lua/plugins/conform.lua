local conform = require("conform")

conform.setup({
  -- =========================================================
  -- Formatters by language
  -- =========================================================

  formatters_by_ft = {
    -- Python
    -- Organize imports and format. No ruff_fix: it would remove currently unused imports on save.
    python = {
      "ruff_organize_imports",
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
    -- Prettier does not understand Django tags ({% %} / {{ }}) and inserts line breaks inside them,
    -- which makes them render as literal text. Django templates (or new files still
    -- detected as "html") are left without a formatter.
    html = function(bufnr)
      local text = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
      local path = vim.api.nvim_buf_get_name(bufnr)
      if text:find("{%", 1, true) or text:find("{{", 1, true) or path:find("/templates/", 1, true) then
        return {}
      end
      return { "prettier" }
    end,

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

  -- If no external formatter is configured,
  -- use the LSP formatter.
  --
  -- This also handles Java/JDTLS, for example.
  default_format_opts = {
    lsp_format = "fallback",
  },

  -- Format automatically before saving.
  format_on_save = {
    timeout_ms = vim.g.format_timeout_ms or 1000,
  },

  notify_on_error = true,
  notify_no_formatters = false,
})
