vim.g.vim_markdown_folding_disabled = 1
vim.g.vim_markdown_conceal = 0
vim.g.vim_markdown_frontmatter = 1

pcall(vim.treesitter.query.set, "markdown", "injections", "")
pcall(vim.treesitter.query.set, "markdown_inline", "injections", "")

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("KaizenMarkdownNoTreesitter", { clear = true }),
    pattern = { "markdown", "markdown.mdx" },
    callback = function(event)
        vim.schedule(function()
            if vim.api.nvim_buf_is_valid(event.buf) then
                pcall(vim.treesitter.stop, event.buf)
                pcall(vim.cmd, "silent! TSBufDisable highlight")
                vim.bo[event.buf].syntax = "markdown"
            end
        end)
    end,
})
