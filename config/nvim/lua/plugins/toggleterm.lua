return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup {
            size = function(term)
                if term.direction == "horizontal" then
                    return 10
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end,
            open_mapping = [[<C-t>]],
            shade_terminals = false,
            direction = "horizontal",
            start_in_insert = true,
            insert_mappings = true,
            terminal_mappings = true,
        }
	vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#0f0e0e", bg = "#0f0e0e" })
    end,
}
