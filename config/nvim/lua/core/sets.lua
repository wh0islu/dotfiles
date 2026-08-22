vim.cmd([[syntax enable]])
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.o.encoding="utf-8"
vim.opt.fileencodings = { "utf-8", "ucs-bom", "default", "latin1" }
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
vim.o.timeoutlen=500
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.cmdheight = 0

local function apply_window_numbers()
    local disabled_filetypes = {
        NvimTree = true,
        kaizen_dashboard = true,
    }

    local disabled_buftypes = {
        nofile = true,
        prompt = true,
        terminal = true,
    }

    if disabled_filetypes[vim.bo.filetype] or disabled_buftypes[vim.bo.buftype] then
        vim.wo.number = false
        vim.wo.relativenumber = false
        return
    end

    vim.wo.number = true
    vim.wo.relativenumber = false
    vim.wo.cursorline = true
    vim.wo.signcolumn = "auto"
end

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "FileType" }, {
    group = vim.api.nvim_create_augroup("KaizenWindowOptions", { clear = true }),
    callback = apply_window_numbers,
})
