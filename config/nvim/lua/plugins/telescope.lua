local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
    defaults = {
        winblend = 0,

        mappings = {
            i = {
                ["<Esc>"] = actions.close,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            },
            n = {
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            },
        },
    },

    pickers = {
        -- =====================================================
        -- Ctrl + F
        -- Search the current file
        -- =====================================================

        current_buffer_fuzzy_find = {
            theme = "dropdown",
            previewer = false,

            layout_config = {
                width = 0.72,
                height = 0.52,
            },
        },

        -- =====================================================
        -- Ctrl + Shift + F
        -- Search the entire project
        --
        -- Layout similar to the official Telescope screenshot:
        -- results on the left + preview on the right.
        -- =====================================================

        live_grep = {
            layout_strategy = "horizontal",

            previewer = true,

            prompt_prefix = "Search: ",
            sorting_strategy = "ascending",

            layout_config = {
                width = 0.88,
                height = 0.72,

                prompt_position = "top",

                horizontal = {
                    preview_width = 0.58,
                    mirror = false,
                },
            },
        },

        -- =====================================================
        -- File search
        -- =====================================================

        find_files = {
            layout_strategy = "horizontal",

            previewer = true,

            prompt_prefix = "Search: ",
            sorting_strategy = "ascending",

            layout_config = {
                width = 0.88,
                height = 0.72,

                prompt_position = "top",

                horizontal = {
                    preview_width = 0.58,
                    mirror = false,
                },
            },
        },
    },
})
