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
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local banner = {
            "",
            " ███╗   ██╗██╗   ██╗██╗███╗   ███╗",
            " ████╗  ██║██║   ██║██║████╗ ████║",
            " ██╔██╗ ██║██║   ██║██║██╔████╔██║",
            " ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
            " ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
            " ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
            "",
        }

        vim.api.nvim_echo({ { table.concat(banner, "\n"), "Normal" } }, false, {})
    end,
})
