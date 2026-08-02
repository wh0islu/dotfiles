require("toggleterm").setup({
    size = 20,
    open_mapping = [[<c-\>]],
    shading_factor = 2,
    direction = "horizontal",
})

local Terminal = require("toggleterm.terminal").Terminal
local codex_bin = "/home/kz/.nvm/versions/node/v22.22.1/lib/node_modules/@openai/codex/bin/codex.js"
local node_bin = "/home/kz/.nvm/versions/node/v22.22.1/bin/node"
local codex_cmd = vim.fn.executable(node_bin) == 1 and vim.fn.filereadable(codex_bin) == 1
    and (node_bin .. " " .. codex_bin)
    or "codex"

local project_terminal = Terminal:new({
    count = 11,
    display_name = "Terminal",
    direction = "horizontal",
    close_on_exit = false,
    hidden = true,
    on_open = function()
        vim.cmd("wincmd J")
        vim.cmd("resize 20")
        vim.cmd("startinsert!")
    end,
})

local runserver = Terminal:new({
    count = 12,
    display_name = "Runserver",
    cmd = "python manage.py runserver",
    direction = "horizontal",
    close_on_exit = false,
    hidden = true,
    on_open = function()
        vim.cmd("wincmd J")
        vim.cmd("resize 20")
        vim.cmd("startinsert!")
    end,
})

local npm_dev = Terminal:new({
    count = 13,
    display_name = "npm dev",
    cmd = "npm run dev",
    direction = "horizontal",
    close_on_exit = false,
    hidden = true,
    on_open = function()
        vim.cmd("wincmd J")
        vim.cmd("resize 20")
        vim.cmd("startinsert!")
    end,
})

local lazygit = Terminal:new({
    count = 14,
    display_name = "Lazygit",
    cmd = "lazygit",
    direction = "float",
    close_on_exit = true,
    hidden = true,
})

local function codex_width()
    return math.max(70, math.floor(vim.o.columns * 0.38))
end

local codex = Terminal:new({
    count = 99,
    display_name = "Codex",
    cmd = codex_cmd,
    direction = "vertical",
    close_on_exit = false,
    hidden = true,
    on_open = function()
        vim.cmd("wincmd L")
        vim.cmd("vertical resize " .. codex_width())
        vim.cmd("startinsert!")
    end,
})

local function open_codex()
    codex.dir = vim.fn.getcwd()
    codex:toggle(codex_width(), "vertical")
end

local function close_codex()
    if codex:is_open() then
        codex:close()
    end
end

local function restart_codex()
    if codex:is_open() then
        codex:close()
    end

    if codex.job_id then
        codex:shutdown()
    end

    codex.dir = vim.fn.getcwd()
    codex:open(codex_width(), "vertical")
end

vim.keymap.set({ "n", "t" }, "<C-t>", function()
    project_terminal:toggle(20, "horizontal")
end, { desc = "Abrir terminal horizontal", noremap = true, silent = true })

vim.keymap.set("n", "<leader>ai", open_codex, { desc = "Abrir Codex lateral", noremap = true, silent = true })
vim.keymap.set("n", "<leader>ac", open_codex, { desc = "Abrir Codex no projeto", noremap = true, silent = true })
vim.keymap.set("n", "<leader>ak", close_codex, { desc = "Fechar Codex", noremap = true, silent = true })
vim.keymap.set("n", "<leader>ar", restart_codex, { desc = "Reiniciar Codex", noremap = true, silent = true })

vim.keymap.set("n", "<leader>tr", function()
    runserver:toggle(20, "horizontal")
end, { desc = "Rodar Django runserver", noremap = true, silent = true })

vim.keymap.set("n", "<leader>tn", function()
    npm_dev:toggle(20, "horizontal")
end, { desc = "Rodar npm run dev", noremap = true, silent = true })

vim.keymap.set("n", "<leader>tg", function()
    if vim.fn.executable("lazygit") == 0 then
        vim.notify("lazygit nao esta instalado.", vim.log.levels.WARN)
        return
    end

    lazygit:toggle()
end, { desc = "Abrir lazygit", noremap = true, silent = true })

vim.keymap.set("n", "<leader>gt", function()
    if vim.fn.executable("lazygit") == 0 then
        vim.notify("lazygit nao esta instalado.", vim.log.levels.WARN)
        return
    end

    lazygit:toggle()
end, { desc = "Abrir lazygit", noremap = true, silent = true })
