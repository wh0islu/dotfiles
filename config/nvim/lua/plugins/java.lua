local ok, jdtls = pcall(require, "jdtls")
if not ok then
    return
end

local root_markers = {
    "mvnw",
    "gradlew",
    "pom.xml",
    "build.gradle",
    "build.gradle.kts",
    "settings.gradle",
    "settings.gradle.kts",
    ".git",
}

local root_dir = require("jdtls.setup").find_root(root_markers)
if not root_dir then
    vim.notify("Java project root not found.", vim.log.levels.WARN)
    return
end

local mason_dir = vim.fn.stdpath("data") .. "/mason"
local jdtls_dir = mason_dir .. "/packages/jdtls"
local launcher = vim.fn.glob(jdtls_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local config_dir = jdtls_dir .. "/config_linux"

if launcher == "" or vim.fn.isdirectory(config_dir) == 0 then
    vim.notify("jdtls is not installed. Run :MasonInstall jdtls", vim.log.levels.WARN)
    return
end

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name
local java_21 = "/usr/lib/jvm/java-21-openjdk/bin/java"
local java_cmd = vim.fn.executable(java_21) == 1 and java_21 or "java"

local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

local config = {
    cmd = {
        java_cmd,
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-jar",
        launcher,
        "-configuration",
        config_dir,
        "-data",
        workspace_dir,
    },
    root_dir = root_dir,
    capabilities = capabilities,
    settings = {
        java = {
            configuration = {
                updateBuildConfiguration = "interactive",
            },
            completion = {
                favoriteStaticMembers = {
                    "org.assertj.core.api.Assertions.assertThat",
                    "org.junit.jupiter.api.Assertions.*",
                    "org.mockito.Mockito.*",
                },
            },
            inlayHints = {
                parameterNames = {
                    enabled = "all",
                },
            },
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
        },
    },
}

jdtls.start_or_attach(config)

pcall(require("jdtls.setup").add_commands)

local opts = { buffer = true, silent = true, noremap = true }

vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, opts)
vim.keymap.set("v", "<leader>jv", function()
    jdtls.extract_variable(true)
end, opts)
vim.keymap.set("v", "<leader>jc", function()
    jdtls.extract_constant(true)
end, opts)
vim.keymap.set("v", "<leader>jm", function()
    jdtls.extract_method(true)
end, opts)
