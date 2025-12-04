local colors = {
    bg = "#0f0f0f",
    fg = "#d8dee9",
    red_pastel = "#E57373",
    green_pastel = "#A5D6A7",
    blue_pastel = "#81A1C1",
    yellow_pastel = "#FFF59D",
    magenta_pastel = "#CE93D8",
    cyan_pastel = "#80CBC4",
    gray = "#5d5d5d",
}

local function apply_theme()
    vim.cmd("highlight Normal guibg=" .. colors.bg .. " guifg=" .. colors.fg)
    vim.cmd("highlight Comment guifg=" .. colors.gray .. " gui=italic")
    vim.cmd("highlight Keyword guifg=" .. colors.blue_pastel .. " gui=bold")
    vim.cmd("highlight String guifg=" .. colors.green_pastel)
    vim.cmd("highlight Function guifg=" .. colors.red_pastel .. " gui=bold")
    vim.cmd("highlight Error guifg=" .. colors.red_pastel .. " gui=bold")
    vim.cmd("highlight Type guifg=" .. colors.cyan_pastel .. " gui=bold")
    vim.cmd("highlight Identifier guifg=" .. colors.magenta_pastel)
    vim.cmd("highlight Constant guifg=" .. colors.yellow_pastel)
    vim.cmd("highlight Visual guibg=" .. colors.gray)
    vim.cmd("highlight StatusLine guibg=" .. colors.bg .. " guifg=" .. colors.yellow_pastel)
end

apply_theme()

return colors
