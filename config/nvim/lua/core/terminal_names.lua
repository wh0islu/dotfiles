local M = {}

local names = {
    ["11"] = "Terminal",
    ["12"] = "Runserver",
    ["13"] = "npm dev",
    ["14"] = "Lazygit",
    ["99"] = "Codex",
}

function M.from_buffer(bufnr)
    if type(bufnr) ~= "number" or not vim.api.nvim_buf_is_valid(bufnr) then
        return nil
    end

    local name = vim.api.nvim_buf_get_name(bufnr)
    local id = name:match("#toggleterm#(%d+)")

    if id and names[id] then
        return names[id]
    end

    if name:match("^term://") then
        return "Terminal"
    end

    return nil
end

return M
