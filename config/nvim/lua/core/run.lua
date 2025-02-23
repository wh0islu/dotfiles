function Run()
    local filetype = vim.fn.expand("%:e")
    local command = ""

    if filetype == "py" then
        command = "python3 " .. vim.fn.expand("%")
    elseif filetype == "c" then
        command = "gcc " .. vim.fn.expand("%") .. " -o output && ./output"
    elseif filetype == "rs" then
        command = "rustc " .. vim.fn.expand("%") .. " && ./output"
    elseif filetype == "go" then
        command = "go run " .. vim.fn.expand("%")
    elseif filetype == "js" then
        if vim.fn.filereadable("yarn.lock") == 1 then
            command = "yarn dev"
        else
            command = "nodemon " .. vim.fn.expand("%")
        end
    else
        print("Unsupported programming language.")
        return
    end

    vim.cmd('w')
    vim.cmd('AsyncRun ' .. command)
end

vim.api.nvim_create_user_command('Run', Run, {})
