local colors = {
  bg = "#111318",
  bg_dark = "#0D0F14",
  bg_float = "#171A22",
  bg_soft = "#1C202A",
  bg_visual = "#2A3140",
  border = "#303746",
  fg = "#E6EAF0",
  fg_soft = "#C9D1DC",
  muted = "#7D8594",
  comment = "#5F6878",
  muted_soft = "#5F6878",

  red = "#FF6B6B",
  red_soft = "#E06C75",
  green = "#7ED7A8",
  yellow = "#F2C66D",
  orange = "#FFB86C",
  blue = "#8FB7FF",
  blue_soft = "#A8C7FF",
  purple = "#C7A4FF",
  pink = "#FF9AC1",
  teal = "#79D7D2",
  teal_soft = "#6FC7C2",
}

vim.g.colors_name = "kaizen"
vim.opt.termguicolors = true

-- lua/themes/kaizen.lua

vim.api.nvim_set_hl(0, "Visual", {
    bg = "#264F78",
})

vim.api.nvim_set_hl(0, "VisualNOS", {
    bg = "#264F78",
})

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

local function apply_theme()
  hi("Normal", { fg = colors.fg, bg = colors.bg })
  hi("NormalNC", { fg = colors.fg_soft, bg = colors.bg })
  hi("EndOfBuffer", { fg = colors.bg, bg = colors.bg })
  hi("SignColumn", { fg = colors.fg_soft, bg = colors.bg })
  hi("FoldColumn", { fg = colors.muted, bg = colors.bg })
  hi("ColorColumn", { bg = colors.bg_soft })
  hi("CursorLine", { bg = colors.bg_soft })
  hi("CursorLineNr", { fg = colors.yellow, bg = colors.bg_soft, bold = true })
  hi("LineNr", { fg = colors.muted_soft })
  hi("Visual", { bg = colors.bg_visual })
  hi("Search", { fg = colors.bg_dark, bg = colors.yellow })
  hi("IncSearch", { fg = colors.bg_dark, bg = colors.orange })
  hi("CurSearch", { fg = colors.bg_dark, bg = colors.orange })
  hi("MatchParen", { fg = colors.yellow, bg = colors.bg_soft, bold = true })
  hi("Pmenu", { fg = colors.fg, bg = colors.bg_float })
  hi("PmenuSel", { fg = colors.bg_dark, bg = colors.blue })
  hi("PmenuSbar", { bg = colors.bg_soft })
  hi("PmenuThumb", { bg = colors.border })
  hi("WinSeparator", { fg = colors.border, bg = colors.bg })
  hi("VertSplit", { fg = colors.border, bg = colors.bg })
  hi("FloatBorder", { fg = colors.border, bg = colors.bg_float })
  hi("NormalFloat", { fg = colors.fg, bg = colors.bg_float })
  hi("Title", { fg = colors.blue, bold = true })
  hi("Directory", { fg = colors.blue })

  hi("Comment", { fg = colors.comment })
  hi("SpecialComment", { fg = colors.comment })
  hi("pythonDocstring", { fg = colors.comment })
  hi("Constant", { fg = colors.yellow })
  hi("String", { fg = colors.green })
  hi("Character", { fg = colors.green })
  hi("Number", { fg = colors.orange })
  hi("Boolean", { fg = colors.orange })
  hi("Float", { fg = colors.orange })
  hi("Identifier", { fg = colors.fg })
  hi("Function", { fg = colors.blue, bold = true })
  hi("Statement", { fg = colors.purple })
  hi("Conditional", { fg = colors.purple })
  hi("Repeat", { fg = colors.purple })
  hi("Label", { fg = colors.purple })
  hi("Operator", { fg = colors.fg_soft })
  hi("Keyword", { fg = colors.purple, bold = true })
  hi("Exception", { fg = colors.red })
  hi("PreProc", { fg = colors.pink })
  hi("Include", { fg = colors.pink })
  hi("Define", { fg = colors.pink })
  hi("Macro", { fg = colors.pink })
  hi("Type", { fg = colors.teal })
  hi("StorageClass", { fg = colors.teal })
  hi("Structure", { fg = colors.teal })
  hi("Typedef", { fg = colors.teal })
  hi("Special", { fg = colors.blue_soft })
  hi("Underlined", { fg = colors.blue, underline = true })
  hi("Todo", { fg = colors.bg_dark, bg = colors.yellow, bold = true })

  hi("Error", { fg = colors.red })
  hi("ErrorMsg", { fg = colors.red })
  hi("WarningMsg", { fg = colors.yellow })
  hi("MoreMsg", { fg = colors.green })
  hi("Question", { fg = colors.blue })

  hi("DiagnosticError", { fg = colors.red })
  hi("DiagnosticWarn", { fg = colors.yellow })
  hi("DiagnosticInfo", { fg = colors.blue })
  hi("DiagnosticHint", { fg = colors.teal_soft })
  hi("DiagnosticOk", { fg = colors.green })
  hi("DiagnosticVirtualTextError", { fg = colors.red_soft, bg = colors.bg_soft })
  hi("DiagnosticVirtualTextWarn", { fg = colors.yellow, bg = colors.bg_soft })
  hi("DiagnosticVirtualTextInfo", { fg = colors.blue, bg = colors.bg_soft })
  hi("DiagnosticVirtualTextHint", { fg = colors.teal_soft, bg = colors.bg_soft })

  hi("StatusLine", { fg = colors.fg, bg = colors.bg_float })
  hi("StatusLineNC", { fg = colors.muted, bg = colors.bg_dark })
  hi("TabLine", { fg = colors.muted, bg = colors.bg_dark })
  hi("TabLineSel", { fg = colors.fg, bg = colors.bg_soft, bold = true })
  hi("TabLineFill", { bg = colors.bg_dark })

  hi("NvimTreeNormal", { fg = colors.fg_soft, bg = colors.bg })
  hi("NvimTreeNormalNC", { fg = colors.fg_soft, bg = colors.bg })
  hi("NvimTreeEndOfBuffer", { fg = colors.bg, bg = colors.bg })
  hi("NvimTreeWinSeparator", { fg = colors.border, bg = colors.bg })
  hi("NvimTreeRootFolder", { fg = colors.blue, bold = true })
  hi("NvimTreeFolderName", { fg = colors.fg_soft })
  hi("NvimTreeOpenedFolderName", { fg = colors.blue, bold = true })
  hi("NvimTreeEmptyFolderName", { fg = colors.muted })
  hi("NvimTreeFolderIcon", { fg = colors.blue_soft })
  hi("NvimTreeOpenedFolderIcon", { fg = colors.blue })
  hi("NvimTreeFileIcon", { fg = colors.fg_soft })
  hi("NvimTreeIndentMarker", { fg = colors.muted_soft })
  hi("NvimTreeGitDirty", { fg = colors.yellow })
  hi("NvimTreeGitNew", { fg = colors.green })
  hi("NvimTreeGitDeleted", { fg = colors.red })
  hi("NvimTreeGitStaged", { fg = colors.green })
  hi("NvimTreeGitMerge", { fg = colors.purple })
  hi("NvimTreeGitRenamed", { fg = colors.teal_soft })
  hi("NvimTreeSpecialFile", { fg = colors.yellow, bold = true })
  hi("NvimTreeSymlink", { fg = colors.teal_soft })
  hi("NvimTreeCursorLine", { bg = colors.bg_soft })
  hi("NvimTreeExecFile", { fg = colors.green })

  hi("TelescopeNormal", { fg = colors.fg, bg = colors.bg_float })
  hi("TelescopeBorder", { fg = colors.border, bg = colors.bg_float })
  hi("TelescopePromptNormal", { fg = colors.fg, bg = colors.bg_soft })
  hi("TelescopePromptBorder", { fg = colors.border, bg = colors.bg_soft })
  hi("TelescopePromptPrefix", { fg = colors.blue })
  hi("TelescopeSelection", { fg = colors.fg, bg = colors.bg_soft, bold = true })
  hi("TelescopeMatching", { fg = colors.yellow, bold = true })

  hi("CmpItemAbbr", { fg = colors.fg })
  hi("CmpItemAbbrDeprecated", { fg = colors.muted, strikethrough = true })
  hi("CmpItemAbbrMatch", { fg = colors.blue, bold = true })
  hi("CmpItemAbbrMatchFuzzy", { fg = colors.blue, bold = true })
  hi("CmpItemMenu", { fg = colors.muted })
  hi("CmpItemKindFunction", { fg = colors.blue })
  hi("CmpItemKindMethod", { fg = colors.blue })
  hi("CmpItemKindVariable", { fg = colors.fg_soft })
  hi("CmpItemKindKeyword", { fg = colors.purple })
  hi("CmpItemKindClass", { fg = colors.teal })
  hi("CmpItemKindInterface", { fg = colors.teal })
  hi("CmpItemKindText", { fg = colors.green })
  hi("CmpItemKindSnippet", { fg = colors.pink })

  hi("BufferLineFill", { bg = colors.bg_dark })
  hi("BufferLineBackground", { fg = colors.muted, bg = colors.bg_dark })
  hi("BufferLineBufferSelected", { fg = colors.fg, bg = colors.bg, bold = true })
  hi("BufferLineIndicatorSelected", { fg = colors.blue, bg = colors.bg })
  hi("BufferLineSeparator", { fg = colors.bg_dark, bg = colors.bg_dark })
  hi("BufferLineSeparatorSelected", { fg = colors.bg_dark, bg = colors.bg })
  hi("BufferLineModified", { fg = colors.yellow, bg = colors.bg_dark })
  hi("BufferLineModifiedSelected", { fg = colors.yellow, bg = colors.bg })

  hi("GitSignsAdd", { fg = colors.green, bg = colors.bg })
  hi("GitSignsChange", { fg = colors.yellow, bg = colors.bg })
  hi("GitSignsDelete", { fg = colors.red, bg = colors.bg })

  hi("@comment", { fg = colors.comment })
  hi("@comment.documentation", { fg = colors.comment })
  hi("@comment.error", { fg = colors.red })
  hi("@comment.warning", { fg = colors.yellow })
  hi("@comment.note", { fg = colors.comment })
  hi("@comment.todo", { fg = colors.yellow })
  hi("@string.documentation", { fg = colors.comment })
  hi("@string.documentation.python", { fg = colors.comment })
  hi("@keyword", { fg = colors.purple, bold = true })
  hi("@keyword.function", { fg = colors.purple, bold = true })
  hi("@string", { fg = colors.green })
  hi("@number", { fg = colors.orange })
  hi("@boolean", { fg = colors.orange })
  hi("@function", { fg = colors.blue, bold = true })
  hi("@function.call", { fg = colors.blue })
  hi("@method", { fg = colors.blue })
  hi("@constructor", { fg = colors.teal })
  hi("@type", { fg = colors.teal })
  hi("@variable", { fg = colors.fg })
  hi("@variable.builtin", { fg = colors.red })
  hi("@property", { fg = colors.fg_soft })
  hi("@field", { fg = colors.fg_soft })
  hi("@parameter", { fg = colors.orange })
  hi("@punctuation", { fg = colors.muted })
  hi("@operator", { fg = colors.fg_soft })
  hi("@tag", { fg = colors.purple })
  hi("@tag.attribute", { fg = colors.yellow })
end

apply_theme()

return colors
