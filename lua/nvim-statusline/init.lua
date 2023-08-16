_G.statusline = {}

local async = false
local async_lhs_color = "Constant"
local default_lhs_color = "Identifier"
local modified_lhs_color = "ModeMsg"
local status_highlight = default_lhs_color

require("nvim-statusline.get-file-info")
require("nvim-statusline.get-git-info")
require("nvim-statusline.get-lsp-info")
require("nvim-statusline.lhs")
require("nvim-statusline.rhs")
require("nvim-statusline.chs")
require("nvim-statusline.highlight")

local update_statusline = function(default, action)
  local result
  local filetype = vim.bo.filetype

  if filetype == "diff" then
    if vim.b.isUndotreeBuffer == 1 then
      result = "Undotree preview"
    else
      result = 1
    end
  elseif filetype == "undotree" then
    result = 0
  elseif filetype == "qf" then
    result = table.concat({
      "%7*",
      "%{v:lua.statusline.lhs()}",
      "%*",
      "%4*",
      "",
      " ",
      "%*",
      "%3*",
      "%q",
      " ",
      "%{get(w:,'quickfix_title','')}",
      "%*",
      "%<",
      " ",
      "%=",
      " ",
      "",
      "%5*",
      "%{v:lua.statusline.rhs()}",
      "%*",
    })
  else
    result = 1
  end

  if result == 0 then
    -- Do nothing.
  elseif result == 1 then
    vim.wo.statusline = default
  else
    vim.wo.statusline = result
  end
end

statusline.check_modified = function()
  local modified = vim.bo.modified
  if modified and status_highlight ~= modified_lhs_color then
    status_highlight = modified_lhs_color
    statusline.update_highlight()
  elseif not modified then
    if async and status_highlight ~= async_lhs_color then
      status_highlight = async_lhs_color
      statusline.update_highlight()
    elseif not async and status_highlight ~= default_lhs_color then
      status_highlight = default_lhs_color
      statusline.update_highlight()
    end
  end
end

statusline.gutterpadding = function()
  local signcolumn = 0
  local option = vim.wo.signcolumn
  if option == "yes" then
    signcolumn = 2
  elseif option == "auto" then
    local signs = vim.fn.sign_getplaced("")
    if #signs[1].signs > 0 then
      signcolumn = 2
    end
  end

  local minwidth = 2
  local numberwidth = vim.wo.numberwidth
  local row = vim.api.nvim_buf_line_count(0)
  local gutterwidth = math.max((#tostring(row) + 1), minwidth, numberwidth) + signcolumn
  local padding = (" "):rep(gutterwidth - 1)

  return padding
end

statusline.setup = function()
  local modified = ""
  if vim.bo.modified then
    modified = "✘ "
  end

  vim.opt.statusline = table.concat({
    "%7*",
    "%{v:lua.statusline.lhs()}",
    "%*",
    "%4*",
    "",
    "%*",
    " ",
    "%3*",
    "%{v:lua.statusline.chs()}",
    "%*",
    "%=",
    " ",
    "",
    "%5*",
    "%{v:lua.statusline.rhs()}",
    "%*",
  })

  statusline.check_modified()
  statusline.update_highlight(status_highlight)
end

require("nvim-statusline.autocmds")

return statusline
