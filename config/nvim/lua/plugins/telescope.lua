require("telescope").load_extension("ui-select")
require("telescope").setup({
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown({})
        }
    }
})
