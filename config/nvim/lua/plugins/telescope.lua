local ok, telescope = pcall(require, "telescope")
if not ok then
    return
end

telescope.setup({
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown({})
        }
    }
})

pcall(telescope.load_extension, "ui-select")

local builtin = require("telescope.builtin")
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>ff", builtin.find_files, opts)
vim.keymap.set("n", "<leader>fg", builtin.live_grep, opts)
vim.keymap.set("n", "<leader>fb", builtin.buffers, opts)
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, opts)
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, opts)
vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, opts)
vim.keymap.set("n", "<leader>fS", builtin.lsp_dynamic_workspace_symbols, opts)
