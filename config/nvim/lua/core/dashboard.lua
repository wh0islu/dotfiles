local M = {}
local project_root = vim.fn.expand("~/Developments/Git")

local header = {
[[                  ;i.                     ]],
[[                  M$L                    .;i.]],
[[                  M$Y;                .;iii;;.]],
[[                 ;$YY$i._           .iiii;;;;;]],
[[                .iiiYYYYYYiiiii;;;;i;iii;; ;;;]],
[[              .;iYYYYYYiiiiiiYYYiiiiiii;;  ;;;]],
[[           .YYYY$$$$YYYYYYYYYYYYYYYYiii;; ;;;;]],
[[         .YYY$$$$$$YYYYYY$$$$iiiY$$$$$$$ii;;;;]],
[[        :YYYF`,  TYYYYY$$$$$YYYYYYYi$$$$$iiiii;]],
[[        Y$MM: \  :YYYY$$P"````"T$YYMMMMMMMMiiYY.]],
[[     `.;$$M$$b.,dYY$$Yi; .(     .YYMMM$$$MMMMYY]],
[[   .._$MMMMM$!YYYYYYYYYi;.`"  .;iiMMM$MMMMMMMYY]],
[[    ._$MMMP` ```""4$$$$$iiiiiiii$MMMMMMMMMMMMMY;]],
[[     MMMM$:       :$$$$$$$MMMMMMMMMMM$$MMMMMMMYYL]],
[[    :MMMM$$.    .;PPb$$$$MMMMMMMMMM$$$$MMMMMMiYYU:]],
[[     iMM$$;;: ;;;;i$$$$$$$MMMMM$$$$MMMMMMMMMMYYYYY]],
[[     `$$$$i .. ``:iiii!*"``.$$$$$$$$$MMMMMMM$YiYYY]],
[[      :Y$$iii;;;.. ` ..;;i$$$$$$$$$MMMMMM$$YYYYiYY:]],
[[       :$$$$$iiiiiii$$$$$$$$$$$MMMMMMMMMMYYYYiiYYYY.]],
[[        `$$$$$$$$$$$$$$$$$$$$MMMMMMMM$YYYYYiiiYYYYYY]],
[[         YY$$$$$$$$$$$$$$$$MMMMMMM$$YYYiiiiiiYYYYYYY]],
[[        :YYYYYY$$$$$$$$$$$$$$$$$$YYYYYYYiiiiYYYYYYi']],
}

local menu = {
{ icon = "󰏗", label = "Projects", key = "p", action = function() M.projects() end },
{ icon = "󰱼", label = "Find Files", key = "f", action = "<cmd>Telescope find_files<CR>" },
{ icon = "󰱽", label = "Live Grep", key = "g", action = "<cmd>Telescope live_grep<CR>" },
{ icon = "󰦛", label = "Restore Session", key = "s", action = function() M.restore_session() end },
{ icon = "", label = "Config", key = "c", action = "<cmd>edit ~/.config/nvim/init.lua<CR>" },
{ icon = "󰒲", label = "Lazy", key = "L", action = "<cmd>Lazy<CR>" },
{ icon = "󰗼", label = "Quit", key = "q", action = "<cmd>qa<CR>" },
}

local function pad(line, width)
  local padding = math.max(math.floor((width - vim.fn.strdisplaywidth(line)) / 2), 0)
  return string.rep(" ", padding) .. line
end

local function build_menu_line(item)
  local left = string.format("%s  %s", item.icon, item.label)
  local spacing = math.max(34 - vim.fn.strdisplaywidth(left), 2)
  return left .. string.rep(" ", spacing) .. item.key
end

local function git_branch()
  local branch = vim.fn.systemlist({ "git", "branch", "--show-current" })[1]
  if vim.v.shell_error ~= 0 or branch == nil or branch == "" then
    return nil
  end

  return branch
end

local function dashboard_context()
  local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
  local branch = git_branch()
  if branch then
    return cwd .. "  󰊢 " .. branch
  end

  return cwd
end

local function build_lines()
  local width = vim.o.columns
  local height = vim.o.lines
  local content = {}

  for _, line in ipairs(header) do
    table.insert(content, pad(line, width))
  end

  table.insert(content, "")
  table.insert(content, pad(dashboard_context(), width))
  table.insert(content, "")
  table.insert(content, "")

  for _, item in ipairs(menu) do
    table.insert(content, pad(build_menu_line(item), width))
  end

  local top = math.max(math.floor((height - #content) / 2) - 2, 0)
  local lines = {}
  for _ = 1, top do
    table.insert(lines, "")
  end
  vim.list_extend(lines, content)

  return lines
end

local function apply_highlights(buf)
  local ns = vim.api.nvim_create_namespace("KaizenDashboard")
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  for index, line in ipairs(lines) do
    if line:find("Projects", 1, true)
      or line:find("Restore Session", 1, true)
      or line:find("Find Files", 1, true)
      or line:find("Live Grep", 1, true)
      or line:find("Config", 1, true)
      or line:find("Lazy", 1, true)
      or line:find("Quit", 1, true) then
      vim.api.nvim_buf_add_highlight(buf, ns, "Comment", index - 1, 0, -1)
    elseif line:find("~", 1, true) then
      vim.api.nvim_buf_add_highlight(buf, ns, "Comment", index - 1, 0, -1)
    elseif line ~= "" then
      vim.api.nvim_buf_add_highlight(buf, ns, "DashboardHeader", index - 1, 0, -1)
    end
  end
end

local function get_projects()
  if vim.fn.isdirectory(project_root) == 0 then
    return {}
  end

  local paths = vim.fn.systemlist({
    "find",
    project_root,
    "-maxdepth",
    "3",
    "-type",
    "d",
    "-name",
    ".git",
    "-printf",
    "%h\n",
  })

  if vim.v.shell_error ~= 0 then
    return {}
  end

  table.sort(paths)

  local projects = {}
  for _, path in ipairs(paths) do
    if path ~= "" then
      table.insert(projects, {
        path = path,
        display = vim.fn.fnamemodify(path, ":~"),
      })
    end
  end

  return projects
end

local function open_project(path)
  vim.cmd("cd " .. vim.fn.fnameescape(path))
  vim.cmd("enew")
  pcall(vim.cmd, "NvimTreeOpen")
end

function M.projects()
  local projects = get_projects()
  if #projects == 0 then
    vim.notify("Nenhum repositorio encontrado em " .. project_root, vim.log.levels.WARN)
    return
  end

  pcall(function()
    require("lazy").load({ plugins = { "telescope.nvim" } })
  end)

  local ok, pickers = pcall(require, "telescope.pickers")
  if not ok then
    open_project(projects[1].path)
    return
  end

  local finders = require("telescope.finders")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local conf = require("telescope.config").values

  pickers.new({}, {
    prompt_title = "Projects",
    finder = finders.new_table({
      results = projects,
      entry_maker = function(project)
        return {
          value = project,
          display = project.display,
          ordinal = project.display,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        if selection and selection.value then
          open_project(selection.value.path)
        end
      end)

      return true
    end,
  }):find()
end

function M.restore_session()
  pcall(function()
    require("lazy").load({ plugins = { "persistence.nvim" } })
  end)

  local ok, persistence = pcall(require, "persistence")
  if ok then
    persistence.load()
    return
  end

  vim.cmd("Telescope oldfiles")
end

function M.open()
  if vim.fn.argc() > 0 or vim.bo.filetype ~= "" or vim.fn.line("$") ~= 1 or vim.fn.getline(1) ~= "" then
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].buflisted = false
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_var(
  buf,
  "kaizen_dashboard_branch",
  git_branch() or ""
)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, build_lines())
  vim.bo[buf].modifiable = false

  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.cursorline = false
  vim.wo.signcolumn = "no"
  vim.wo.foldcolumn = "0"

  local theme_colors = vim.g.kaizen_theme_colors or {}
  vim.api.nvim_set_hl(0, "DashboardHeader", {
    fg = theme_colors.muted or "#7D8594",
    bg = theme_colors.bg or "#080808",
  })
  apply_highlights(buf)

  for _, item in ipairs(menu) do
    vim.keymap.set("n", item.key, item.action, { buffer = buf, silent = true })
  end

  vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files<CR>", { buffer = buf, silent = true })
end

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("KaizenDashboard", { clear = true }),
  callback = M.open,
})

return M
