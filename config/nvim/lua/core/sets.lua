vim.cmd([[syntax enable]])
vim.o.encoding="utf-8"
vim.o.fileencoding="utf-8"
vim.o.hidden=true
vim.o.smarttab=true
vim.o.autoindent=true
vim.o.ruler=true
vim.o.shiftwidth=4
vim.o.softtabstop=4
vim.o.numberwidth=4
vim.o.number=true
vim.o.showtabline=2
vim.o.updatetime=100
vim.o.timeoutlen=100
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.cmdheight = 0
vim.opt.fillchars:append({
    eob = " ",
})

local function apply_interface_highlights()
    local bg = "#0f0f0f"

    vim.api.nvim_set_hl(0, "WinSeparator", {
        fg = bg,
        bg = bg,
    })
    vim.api.nvim_set_hl(0, "VertSplit", {
        fg = bg,
        bg = bg,
    })
end

apply_interface_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("UserInterfaceHighlights", { clear = true }),
    callback = apply_interface_highlights,
})
