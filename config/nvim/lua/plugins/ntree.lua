require("nvim-tree").setup({
    view = {
        width = 28,
        side = 'left',
        signcolumn = "no",
    },
    renderer = {
        highlight_opened_files = "none",
        full_name = true,
        root_folder_label = false,
        icons = {
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
                modified = true,
                diagnostics = true,
                bookmarks = true,
            },
        },
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
