local function file_exists(path)
    return vim.fn.filereadable(path) == 1
end

local function project_file(name)
    return vim.fn.getcwd() .. "/" .. name
end

local function shellescape(path)
    return vim.fn.shellescape(path)
end

local function project_glob(pattern)
    return vim.fn.globpath(vim.fn.getcwd(), pattern, false, true)
end

local function current_file()
    return shellescape(vim.fn.expand("%:p"))
end

local function java_home_prefix()
    local java_21_home = require("core.environment").java_home()

    if java_21_home then
        return "JAVA_HOME=" .. shellescape(java_21_home) .. " PATH=" .. shellescape(java_21_home .. "/bin") .. ":$PATH "
    end

    return ""
end

local function java_class_name(path)
    local package_name = nil
    local class_name = nil

    for _, line in ipairs(vim.fn.readfile(path)) do
        package_name = package_name or line:match("^%s*package%s+([%w_.]+)%s*;")
        class_name = class_name or line:match("^%s*public%s+class%s+([%w_]+)")
        class_name = class_name or line:match("^%s*class%s+([%w_]+)")

        if package_name and class_name then
            break
        end
    end

    if not class_name then
        return nil
    end

    if package_name then
        return package_name .. "." .. class_name
    end

    return class_name
end

local function spring_main_class()
    local fallback = nil

    for _, path in ipairs(project_glob("src/main/java/**/*.java")) do
        local content = table.concat(vim.fn.readfile(path), "\n")
        local class_name = java_class_name(path)

        if class_name and content:find("@SpringBootApplication", 1, true) then
            return class_name
        end

        if not fallback and class_name and content:find("public static void main", 1, true) then
            fallback = class_name
        end
    end

    return fallback
end

local function spring_main_property()
    local main_class = spring_main_class()

    if main_class then
        return " -Dspring-boot.run.main-class=" .. shellescape(main_class)
    end

    return ""
end

local function project_contains(name, text)
    local path = project_file(name)
    return file_exists(path) and table.concat(vim.fn.readfile(path), "\n"):find(text, 1, true) ~= nil
end

local function uses_poetry()
    return project_contains("pyproject.toml", "[tool.poetry") or file_exists(project_file("poetry.lock"))
end

local function command_for_file()
    local ext = vim.fn.expand("%:e")

    if ext == "py" then
        if uses_poetry() and vim.fn.executable("poetry") == 1 then
            return "poetry run python " .. current_file()
        end

        return "python3 " .. current_file()
    end

    if ext == "c" then
        return "gcc " .. current_file() .. " -o output && ./output"
    end

    if ext == "rs" then
        if file_exists(project_file("Cargo.toml")) then
            return "cargo run"
        end

        return "rustc " .. current_file() .. " -o output && ./output"
    end

    if ext == "go" then
        return "go run " .. current_file()
    end

    if ext == "js" then
        return "node " .. current_file()
    end

    if ext == "ts" then
        return "npx ts-node " .. current_file()
    end

    if ext == "java" then
        return java_home_prefix() .. "java " .. current_file()
    end

    return nil
end

local function project_command()
    if file_exists(project_file("pom.xml")) then
        if not project_contains("pom.xml", "spring-boot-maven-plugin") then
            return nil, "Maven project has no Spring Boot plugin. Run its build/run command in the terminal."
        end
        local mvn = file_exists(project_file("mvnw")) and "sh ./mvnw" or "mvn"
        return java_home_prefix() .. mvn .. spring_main_property() .. " spring-boot:run"
    end

    if file_exists(project_file("build.gradle")) or file_exists(project_file("build.gradle.kts")) then
        if not (project_contains("build.gradle", "org.springframework.boot")
            or project_contains("build.gradle.kts", "org.springframework.boot")) then
            return nil, "Gradle project has no explicit Spring Boot plugin. Run its task in the terminal."
        end
        local gradle = file_exists(project_file("gradlew")) and "sh ./gradlew" or "gradle"
        return java_home_prefix() .. gradle .. " bootRun"
    end

    if file_exists(project_file("manage.py")) then
        if uses_poetry() and vim.fn.executable("poetry") == 1 then
            return "poetry run python manage.py runserver"
        end
        return "python manage.py runserver"
    end

    if file_exists(project_file("package.json")) then
        local ok, package = pcall(vim.json.decode, table.concat(vim.fn.readfile(project_file("package.json")), "\n"))
        if not ok or type(package) ~= "table" then
            return nil, "Invalid package.json."
        end
        local scripts = type(package.scripts) == "table" and package.scripts or {}
        for _, name in ipairs({ "dev", "start" }) do
            if type(scripts[name]) == "string" and scripts[name] ~= "" then
                return "npm run " .. name
            end
        end
        return nil, "package.json has no dev or start script."
    end

    if file_exists(project_file("Cargo.toml")) then
        return "cargo run"
    end
    if file_exists(project_file("go.mod")) then
        return "go run ."
    end
end

local function run_in_terminal(command)
    local ok, Terminal = pcall(require, "toggleterm.terminal")
    if not ok then
        vim.cmd("!" .. command)
        return
    end

    Terminal.Terminal:new({
        cmd = command,
        direction = "horizontal",
        close_on_exit = false,
        hidden = true,
        on_open = function()
            vim.cmd("wincmd J")
            vim.cmd("resize 20")
            vim.cmd("startinsert!")
        end,
    }):toggle(20, "horizontal")
end

function Run()
    if vim.bo.buftype == "" and vim.api.nvim_buf_get_name(0) ~= "" then
        vim.cmd("write")
    end
    local command, reason = project_command()
    if reason then
        vim.notify(reason, vim.log.levels.WARN)
        return
    end
    command = command or command_for_file()

    if not command then
        vim.notify("No run command found for this file or project.", vim.log.levels.WARN)
        return
    end

    run_in_terminal(command)
end

vim.api.nvim_create_user_command("Run", Run, {
    desc = "Run current file or project",
    force = true,
})
