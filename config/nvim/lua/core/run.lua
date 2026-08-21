function Run()
    local extension = vim.fn.expand("%:e")
    local file = vim.fn.shellescape(vim.fn.expand("%:p"))
    local basename = vim.fn.expand("%:p:r")
    local is_windows = vim.fn.has("win32") == 1
    local command = nil

    if extension == "py" then
        command = (is_windows and "python " or "python3 ") .. file
    elseif extension == "c" then
        local output = vim.fn.shellescape(basename .. (is_windows and ".exe" or ""))
        command = "gcc " .. file .. " -o " .. output .. " && " .. output
    elseif extension == "rs" then
        local output = vim.fn.shellescape(basename .. (is_windows and ".exe" or ""))
        command = "rustc " .. file .. " -o " .. output .. " && " .. output
    elseif extension == "go" then
        command = "go run " .. file
    elseif extension == "js" then
        command = "node " .. file
    else
        print("Unsupported programming language.")
        return
    end

    vim.cmd("w")
    vim.cmd("!" .. command)
end

vim.api.nvim_create_user_command("Run", Run, {})
