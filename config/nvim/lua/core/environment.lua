local M = {}

function M.projects_root()
    return vim.fn.expand(vim.env.NVIM_PROJECTS_DIR or "~/Developments/Git")
end

-- Explicit overrides take precedence over distro-specific discovery.
function M.java_home()
    for _, name in ipairs({ "NVIM_JAVA_HOME", "JAVA_HOME" }) do
        local value = vim.env[name]
        if value and value ~= "" and vim.fn.executable(value .. "/bin/java") == 1 then
            return value
        end
    end
    for _, pattern in ipairs({ "/usr/lib/jvm/java-21*", "/usr/lib/jvm/jdk-21*" }) do
        for _, path in ipairs(vim.fn.glob(pattern, false, true)) do
            if vim.fn.executable(path .. "/bin/java") == 1 then
                return path
            end
        end
    end
end

function M.java_command()
    local home = M.java_home()
    return home and (home .. "/bin/java") or "java"
end

return M
