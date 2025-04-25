function Run()
    local filetype = vim.fn.expand("%:e")
    local filename = vim.fn.expand("%:p")
    local command = ""
    vim.cmd('w')

    if filetype == "py" then
        command = "python3 " .. filename
    elseif filetype == "c" then
        command = "gcc " .. filename .. " -o output && ./output"
    elseif filetype == "rs" then
        local bin_name = vim.fn.expand("%:t:r")
        command = "rustc " .. filename .. " -o " .. bin_name .. " && ./" .. bin_name
    elseif filetype == "go" then
        command = "go run " .. filename
    elseif filetype == "js" then
        if vim.fn.filereadable("yarn.lock") == 1 then
            command = "yarn dev"
        else
            command = "nodemon " .. filename
        end
    else
        vim.api.nvim_err_writeln("Unsupported programming language: " .. filetype)
        return
    end

    require("toggleterm").exec(command, 1)
end

vim.api.nvim_create_user_command('Run', Run, {})
