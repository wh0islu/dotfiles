local terminal_names = require("core.terminal_names")
local colors = vim.g.kaizen_theme_colors or {
    bg = "#080808",
    bg_soft = "#121212",
    fg = "#E8E8E8",
    muted = "#7A7A7A",
    yellow = "#E6C76A",
    blue = "#7AA2F7",
}

require("bufferline").setup({
    options = {
	numbers = "ordinal",
        diagnostics = "nvim_lsp",
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = "thin",
        always_show_bufferline = false,
        name_formatter = function(buf)
            return terminal_names.from_buffer(buf.bufnr)
        end,
        offsets = {
            {
		filetype = "NvimTree",
                text = "File Explorer",
                highlight = "Directory",
                text_align = "left"
            }
        },
    },
    highlights = {
        fill = { bg = colors.bg },
        background = { fg = colors.muted, bg = colors.bg },
        buffer_selected = { fg = colors.fg, bg = colors.bg, bold = true },
        indicator_selected = { fg = colors.blue, bg = colors.bg },
        separator = { fg = colors.bg, bg = colors.bg },
        separator_selected = { fg = colors.bg, bg = colors.bg },
        separator_visible = { fg = colors.bg, bg = colors.bg },
        modified = { fg = colors.yellow, bg = colors.bg },
        modified_selected = { fg = colors.yellow, bg = colors.bg },
        numbers = { fg = colors.muted, bg = colors.bg },
        numbers_selected = { fg = colors.fg, bg = colors.bg },
        duplicate = { fg = colors.muted, bg = colors.bg },
        duplicate_selected = { fg = colors.fg, bg = colors.bg },
    },
})
