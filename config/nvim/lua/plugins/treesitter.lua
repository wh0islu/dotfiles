return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup {
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            ensure_installed = {"lua", "python", "javascript", "c" },
        }
    end,
}
