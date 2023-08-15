local pinnacle = require("wincent.pinnacle")
local statusline = {}

local async = false
local async_lhs_color = "Constant"
local default_lhs_color = "Identifier"
local modified_lhs_color = "ModeMsg"
local status_highlight = default_lhs_color

local update_statusline = function(default, action)
  local result
  local filetype = vim.bo.filetype

  if filetype == "command-t" then
    result = "  " .. vim.fn.bufname()
  elseif filetype == "diff" then
    if vim.b.isUndotreeBuffer == 1 then
      result = "Undotree preview"
    else
      result = 1
    end
  elseif filetype == "undotree" then
    result = 0
  elseif filetype == "qf" then
    if action == "blur" then
      result = "%{v:lua.plugins.ui.statusline.gutterpadding()}"
        .. " "
        .. " "
        .. " "
        .. " "
        .. "%<"
        .. "%q"
        .. " "
        .. "%{get(w:,'quickfix_title','')}"
        .. "%="
    else
      result = vim.g.WincentQuickfixStatusline or ""
    end
  else
    result = 1
  end

  if result == 0 then
  elseif result == 1 then
    vim.wo.statusline = default
  else
    vim.wo.statusline = result
  end
end

statusline.async_start = function()
  async = true
  statusline.check_modified()
end

statusline.async_finish = function()
  async = false
  statusline.check_modified()
end

statusline.blur_statusline = function()
  local blurred = "%{v:lua.plugins.ui.statusline.gutterpadding()}"
  blurred = blurred .. " "
  blurred = blurred .. " "
  blurred = blurred .. " "
  blurred = blurred .. " "
  blurred = blurred .. "%<"
  blurred = blurred .. "%f"
  blurred = blurred .. "%="
  update_statusline(blurred, "blur")
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

statusline.fileencoding = function()
  local fileencoding = vim.bo.fileencoding
  if #fileencoding > 0 and fileencoding ~= "utf-8" then
    return "," .. fileencoding
  else
    return ""
  end
end

statusline.fileprefix = function()
  local basename = vim.fn.fnamemodify(vim.fn.expand("%:h"), ":p:~:.")
  if basename == "" or basename == "." then
    return ""
  else
    return basename:gsub("/$", "") .. "/"
  end
end

statusline.filetype = function()
  local filetype = vim.bo.filetype
  if #filetype > 0 then
    return "," .. filetype
  else
    return ""
  end
end

statusline.focus_statusline = function()
  update_statusline("", "focus")
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

statusline.lhs = function()
  local padding = statusline.gutterpadding()

  if vim.bo.modified then
    return padding .. "✘ "
  else
    return padding .. "  "
  end
end

statusline.rhs = function()
  local rhs = " "

  if vim.fn.winwidth(0) > 80 then
    local column = vim.fn.virtcol(".")
    local width = vim.fn.virtcol("$")
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local height = vim.api.nvim_buf_line_count(0)

    local padding = #tostring(height) - #tostring(line)
    if padding > 0 then
      rhs = rhs .. (" "):rep(padding)
    end

    rhs = rhs .. "ℓ "
    rhs = rhs .. line
    rhs = rhs .. "/"
    rhs = rhs .. height
    rhs = rhs .. " 𝚌 "
    rhs = rhs .. column
    rhs = rhs .. "/"
    rhs = rhs .. width
    rhs = rhs .. " "

    if #tostring(column) < 2 then
      rhs = rhs .. " "
    end
    if #tostring(width) < 2 then
      rhs = rhs .. " "
    end
  end

  return rhs
end

statusline.set = function()
  vim.opt.statusline = ""
    .. "%7*"
    .. "%{v:lua.plugins.ui.statusline.lhs()}"
    .. "%*"
    .. "%4*"
    .. ""
    .. "%*"
    .. " "
    .. "%<"
    .. "%{v:lua.plugins.ui.statusline.fileprefix()}"
    .. "%3*"
    .. "%t"
    .. "%*"
    .. " "
    .. "%1*"
    .. "%("
    .. "["
    .. "%R"
    .. "%{v:lua.nvim-statusline.filetype()}"
    .. "%{v:lua.nvim-statusline.fileencoding()}"
    .. "]"
    .. "%)"
    .. "%*"
    .. "%="
    .. " "
    .. ""
    .. "%5*"
    .. "%{v:lua.plugins.ui.statusline.rhs()}"
    .. "%*"
end

statusline.update_highlight = function()
  local highlight = pinnacle.italicize("StatusLine")
  vim.cmd("highlight User1 " .. highlight)

  highlight = pinnacle.italicize("MatchParen")
  vim.cmd("highlight User2 " .. highlight)

  highlight = pinnacle.embolden("StatusLine")
  vim.cmd("highlight User3 " .. highlight)

  local fg = pinnacle.extract_fg(status_highlight)
  local bg = pinnacle.extract_bg("StatusLine")
  vim.cmd("highlight User4 " .. pinnacle.highlight({ bg = bg, fg = fg }))

  vim.cmd("highlight User7 " .. pinnacle.highlight({
    bg = fg,
    fg = pinnacle.extract_fg("Normal"),
    term = "bold",
  }))

  bg = pinnacle.extract_fg("Cursor")
  fg = pinnacle.extract_fg("User3")
  vim.cmd("highlight User5 " .. pinnacle.highlight({
    bg = fg,
    fg = bg,
    term = "bold",
  }))

  vim.cmd("highlight User6 " .. pinnacle.highlight({
    bg = fg,
    fg = bg,
    term = "bold,italic",
  }))

  vim.cmd("highlight clear StatusLineNC")
  vim.cmd("highlight! link StatusLineNC User1")
end

statusline.setup = function()
  statusline.set()

  local group = vim.api.nvim_create_augroup("StatusLine", { clear = true })

  vim.api.nvim_create_autocmd(
    "BufWinEnter,BufWritePost,FileWritePost,TextChanged,TextChangedI,WinEnter",
    { command = statusline.check_modified, group = group }
  )

  vim.api.nvim_create_autocmd(
    "ColorScheme",
    { command = statusline.update_highlight, group = group }
  )
end

return statusline
