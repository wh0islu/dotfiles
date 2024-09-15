require("nvim-tree").setup({
    view = {
        width = 30,
        side = 'left',
        signcolumn = "no",
    },
    renderer = {
        highlight_opened_files = "none",
    },
    actions = {
        open_file = {
            window_picker = {
                enable = false,
            },
        },
    },
    hijack_directories = {
        enable = false,
    },
    update_focused_file = {
        enable = true,
        update_cwd = true,
    },
})
