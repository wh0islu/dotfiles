return {
    "nvim-tree/nvim-tree.lua",
    config = function()
        require("nvim-tree").setup {
            view = {
                width = 30,
                side = "left",
            },
            renderer = {
                icons = {
                    glyphs = {
                        default = "",
                        symlink = "",
                        folder = {
                            default = "",
                            open = "",
                        },
                    },
                },
            },
        }
    end,
}
