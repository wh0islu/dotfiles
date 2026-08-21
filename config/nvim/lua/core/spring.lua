local M = {}

local projects_root = vim.fn.expand("~/Developments/Git")
local default_dependencies = "web,validation,lombok,devtools"
local database_dependencies = "data-jpa,postgresql"

local function trim(value)
    return (value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function slugify(value)
    local slug = trim(value):lower()
    slug = slug:gsub("[^%w%-_]+", "-")
    slug = slug:gsub("%-+", "-")
    slug = slug:gsub("^%-", ""):gsub("%-$", "")
    return slug
end

local function package_part(value)
    local part = trim(value):lower()
    part = part:gsub("[^%w]+", "")
    if part == "" then
        return "app"
    end
    if part:match("^%d") then
        return "app" .. part
    end
    return part
end

local function input(prompt, default)
    return trim(vim.fn.input(prompt, default or ""))
end

local function shellescape(value)
    return vim.fn.shellescape(value)
end

local function run(command)
    local output = vim.fn.system(command)
    return vim.v.shell_error == 0, output
end

local function open_project(path)
    vim.cmd("cd " .. vim.fn.fnameescape(path))
    vim.cmd("enew")
    pcall(vim.cmd, "NvimTreeOpen")
end

local function package_to_path(package_name)
    return (package_name:gsub("%.", "/"))
end

local function write_home_controller(project_dir, package_name)
    local package_dir = project_dir .. "/src/main/java/" .. package_to_path(package_name)
    local controller_path = package_dir .. "/HomeController.java"

    if vim.fn.filereadable(controller_path) == 1 then
        return
    end

    vim.fn.mkdir(package_dir, "p")
    vim.fn.writefile({
        "package " .. package_name .. ";",
        "",
        "import org.springframework.web.bind.annotation.GetMapping;",
        "import org.springframework.web.bind.annotation.RestController;",
        "",
        "@RestController",
        "public class HomeController {",
        "",
        "    @GetMapping(\"/\")",
        "    public String home() {",
        "        return \"Spring Boot OK\";",
        "    }",
        "}",
    }, controller_path)
end

function M.new_project()
    if vim.fn.executable("curl") ~= 1 then
        vim.notify("curl is required to create a Spring Boot project.", vim.log.levels.ERROR)
        return
    end

    if vim.fn.executable("unzip") ~= 1 then
        vim.notify("unzip is required to create a Spring Boot project.", vim.log.levels.ERROR)
        return
    end

    local name = input("Project name: ", "meu-projeto")
    if name == "" then
        vim.notify("Project creation cancelled.", vim.log.levels.INFO)
        return
    end

    local artifact = slugify(input("Artifact ID: ", slugify(name)))
    local group = input("Group ID: ", "com.example")
    local package_name = input("Package name: ", group .. "." .. package_part(artifact))
    local build = input("Build tool [maven/gradle]: ", "maven")
    local java_version = input("Java version: ", "21")
    local boot_version = input("Spring Boot version: ", "3.5.0")
    local with_database = input("Include JPA/PostgreSQL? [y/N]: ", "N"):lower()

    local dependencies = default_dependencies
    if with_database == "y" or with_database == "yes" or with_database == "s" or with_database == "sim" then
        dependencies = dependencies .. "," .. database_dependencies
    end

    local project_dir = projects_root .. "/" .. artifact
    if vim.fn.isdirectory(project_dir) == 1 then
        vim.notify("Project already exists: " .. project_dir, vim.log.levels.ERROR)
        return
    end

    vim.fn.mkdir(projects_root, "p")

    local project_type = build == "gradle" and "gradle-project" or "maven-project"
    local zip_path = vim.fn.tempname() .. ".zip"
    local params = {
        "-d type=" .. shellescape(project_type),
        "-d language=java",
        "-d bootVersion=" .. shellescape(boot_version),
        "-d baseDir=" .. shellescape(artifact),
        "-d groupId=" .. shellescape(group),
        "-d artifactId=" .. shellescape(artifact),
        "-d name=" .. shellescape(name),
        "-d packageName=" .. shellescape(package_name),
        "-d packaging=jar",
        "-d javaVersion=" .. shellescape(java_version),
        "-d dependencies=" .. shellescape(dependencies),
    }

    local curl_command = "curl -fsSL https://start.spring.io/starter.zip "
        .. table.concat(params, " ")
        .. " -o "
        .. shellescape(zip_path)

    vim.notify("Creating Spring Boot project: " .. artifact, vim.log.levels.INFO)

    local ok, output = run(curl_command)
    if not ok then
        vim.notify("Spring Initializr failed:\n" .. output, vim.log.levels.ERROR)
        return
    end

    ok, output = run("unzip -q " .. shellescape(zip_path) .. " -d " .. shellescape(projects_root))
    if not ok then
        vim.notify("Failed to unzip project:\n" .. output, vim.log.levels.ERROR)
        return
    end

    write_home_controller(project_dir, package_name)
    open_project(project_dir)
    vim.notify("Spring Boot project created: " .. project_dir, vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("NewSpringBoot", M.new_project, {
    desc = "Create a standardized Spring Boot project",
    force = true,
})

return M
