local terminal_names = require("core.terminal_names")

local colors = vim.g.kaizen_theme_colors or {
  bg = "#080808",
  bg_soft = "#121212",
  fg = "#E8E8E8",
  muted = "#7A7A7A",
  blue = "#7AA2F7",
  green = "#7FD88F",
  yellow = "#E6C76A",
  red = "#FF5F5F",
}

local function filename()
  local terminal_name = terminal_names.from_buffer(0)

  if terminal_name then
    return terminal_name
  end

  local name = vim.fn.expand("%:~:.")

  if name == "" then
    return "[No Name]"
  end

  return name
end

-- =========================================================
-- Python
-- =========================================================

local function python_env()
  local client = vim.lsp.get_clients({ bufnr = 0, name = "basedpyright" })[1]
  local python_path = client
    and client.config.settings
    and client.config.settings.python
    and client.config.settings.python.pythonPath

  if not python_path then
    return ""
  end

  local venv_dir = python_path:match("^(.*)/bin/python$") or python_path
  return " " .. vim.fn.fnamemodify(venv_dir, ":t")
end

-- =========================================================
-- Dashboard
-- =========================================================

local function dashboard_branch()
  return vim.b.kaizen_dashboard_branch or ""
end

local dashboard_extension = {
  filetypes = {
    "kaizen_dashboard",
  },

  sections = {
    lualine_a = {},
    lualine_b = {},

    lualine_c = {
      {
        dashboard_branch,

        color = {
          fg = colors.fg,
          bg = colors.bg,
        },

        padding = {
          left = 1,
          right = 0,
        },
      },
    },

    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },

  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
}

-- =========================================================
-- Lualine
-- =========================================================

require("lualine").setup({
  options = {
    icons_enabled = true,

    theme = {
      normal = {
        a = {
          fg = colors.bg,
          bg = colors.blue,
          gui = "bold",
        },

        b = {
          fg = colors.fg,
          bg = colors.bg_soft,
        },

        c = {
          fg = colors.fg,
          bg = colors.bg,
        },
      },

      insert = {
        a = {
          fg = colors.bg,
          bg = colors.green,
          gui = "bold",
        },

        b = {
          fg = colors.fg,
          bg = colors.bg_soft,
        },

        c = {
          fg = colors.fg,
          bg = colors.bg,
        },
      },

      visual = {
        a = {
          fg = colors.bg,
          bg = colors.yellow,
          gui = "bold",
        },

        b = {
          fg = colors.fg,
          bg = colors.bg_soft,
        },

        c = {
          fg = colors.fg,
          bg = colors.bg,
        },
      },

      replace = {
        a = {
          fg = colors.bg,
          bg = colors.red,
          gui = "bold",
        },

        b = {
          fg = colors.fg,
          bg = colors.bg_soft,
        },

        c = {
          fg = colors.fg,
          bg = colors.bg,
        },
      },

      command = {
        a = {
          fg = colors.bg,
          bg = colors.yellow,
          gui = "bold",
        },

        b = {
          fg = colors.fg,
          bg = colors.bg_soft,
        },

        c = {
          fg = colors.fg,
          bg = colors.bg,
        },
      },

      inactive = {
        a = {
          fg = colors.muted,
          bg = colors.bg,
        },

        b = {
          fg = colors.muted,
          bg = colors.bg,
        },

        c = {
          fg = colors.muted,
          bg = colors.bg,
        },
      },
    },

    component_separators = {
      left = "",
      right = "",
    },

    section_separators = {
      left = "",
      right = "",
    },

    disabled_filetypes = {
      statusline = {
        "NvimTree",
      },

      winbar = {
        "NvimTree",
      },
    },

    ignore_focus = {
      "NvimTree",
    },

    always_divide_middle = true,
    globalstatus = true,

    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    },
  },

  sections = {
    lualine_a = {
      "mode",
    },

    lualine_b = {
      "branch",
      "diff",
      "diagnostics",
    },

    lualine_c = {
      filename,
    },

    lualine_x = {
      {
        python_env,
        cond = function()
          return vim.bo.filetype == "python"
        end,
        color = { fg = colors.muted },
      },
      "filetype",
    },

    lualine_y = {
      "progress",
    },

    lualine_z = {
      "location",
    },
  },

  inactive_sections = {
    lualine_a = {},
    lualine_b = {},

    lualine_c = {
      filename,
    },

    lualine_x = {
      "location",
    },

    lualine_y = {},
    lualine_z = {},
  },

  tabline = {},
  winbar = {},
  inactive_winbar = {},

  extensions = {
    "nvim-tree",
    dashboard_extension,
  },
})
