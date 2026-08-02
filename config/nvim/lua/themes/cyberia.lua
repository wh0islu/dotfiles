local colors = {
  bg = "#080808",
  bg_dark = "#080808",
  bg_float = "#080808",
  bg_soft = "#121212",
  bg_visual = "#222222",
  border = "#080808",
  fg = "#E8E8E8",
  fg_soft = "#C8C8C8",
  muted = "#7A7A7A",
  comment = "#5E5E5E",
  muted_soft = "#4E4E4E",

  red = "#FF5F5F",
  red_soft = "#D75F5F",
  green = "#7FD88F",
  yellow = "#E6C76A",
  orange = "#F0A45D",
  blue = "#7AA2F7",
  blue_soft = "#9AB8FF",
  purple = "#B48EED",
  pink = "#F38BA8",
  teal = "#6BD6D6",
  teal_soft = "#5FBFC0",
}

vim.g.colors_name = "cyberia"
vim.g.kaizen_theme_colors = colors
vim.opt.termguicolors = true

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

local function apply_theme()
  hi("Normal", { fg = colors.fg, bg = colors.bg })
  hi("NormalNC", { fg = colors.fg_soft, bg = colors.bg })
  hi("NonText", { fg = colors.bg, bg = colors.bg })
  hi("Whitespace", { fg = colors.bg, bg = colors.bg })
  hi("EndOfBuffer", { fg = colors.bg, bg = colors.bg })
  hi("SignColumn", { fg = colors.fg_soft, bg = colors.bg })
  hi("LineNrAbove", { fg = colors.muted_soft, bg = colors.bg })
  hi("LineNrBelow", { fg = colors.muted_soft, bg = colors.bg })
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
  hi("WinSeparator", { fg = colors.bg, bg = colors.bg })
  hi("VertSplit", { fg = colors.bg, bg = colors.bg })
  hi("FloatBorder", { fg = colors.bg, bg = colors.bg_float })
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
  hi("StatusLineTerm", { fg = colors.fg, bg = colors.bg })
  hi("StatusLineTermNC", { fg = colors.muted, bg = colors.bg })
  hi("TabLine", { fg = colors.muted, bg = colors.bg_dark })
  hi("TabLineSel", { fg = colors.fg, bg = colors.bg_soft, bold = true })
  hi("TabLineFill", { bg = colors.bg_dark })
  hi("MsgArea", { fg = colors.fg, bg = colors.bg })
  hi("ModeMsg", { fg = colors.blue, bg = colors.bg })
  hi("NormalSB", { fg = colors.fg_soft, bg = colors.bg })

  hi("NvimTreeNormal", { fg = colors.fg_soft, bg = colors.bg })
  hi("NvimTreeNormalNC", { fg = colors.fg_soft, bg = colors.bg })
  hi("NvimTreeEndOfBuffer", { fg = colors.bg, bg = colors.bg })
  hi("NvimTreeWinSeparator", { fg = colors.bg, bg = colors.bg })
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
  hi("TelescopeBorder", { fg = colors.bg, bg = colors.bg_float })
  hi("TelescopePromptNormal", { fg = colors.fg, bg = colors.bg_soft })
  hi("TelescopePromptBorder", { fg = colors.bg, bg = colors.bg_soft })
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
  hi("BufferLineSeparatorVisible", { fg = colors.bg_dark, bg = colors.bg_dark })
  hi("BufferLineTabSeparator", { fg = colors.bg_dark, bg = colors.bg_dark })
  hi("BufferLineTabSeparatorSelected", { fg = colors.bg_dark, bg = colors.bg })
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
