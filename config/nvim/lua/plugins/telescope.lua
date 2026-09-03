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
        -- Busca no arquivo atual
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
        -- Busca em todo o projeto
        --
        -- Layout parecido com o screenshot oficial do Telescope:
        -- resultados à esquerda + preview à direita.
        -- =====================================================

        live_grep = {
            layout_strategy = "horizontal",

            previewer = true,

            prompt_prefix = "Buscar: ",
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
        -- Busca de arquivos
        -- =====================================================

        find_files = {
            layout_strategy = "horizontal",

            previewer = true,

            prompt_prefix = "Buscar: ",
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
