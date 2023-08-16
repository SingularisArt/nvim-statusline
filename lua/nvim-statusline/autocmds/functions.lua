statusline.enable_plugins = function()
  vim.cmd("TSContextEnable")
  vim.cmd("TSBufEnable highlight")
  vim.cmd("IlluminateResumeBuf")
  vim.cmd("IndentBlanklineToggle")
  require("gitsigns").attach()
end

statusline.disable_plugins = function()
  vim.cmd("TSContextDisable")
  vim.cmd("TSBufDisable highlight")
  vim.cmd("IlluminatePauseBuf")
  vim.cmd("IndentBlanklineDisable")
  require("gitsigns").detach()
end

statusline.ownsyntax = function(active)
  local flag = vim.w[statusline.ownsyntax_flag]

  if active and flag == false then
    vim.cmd("ownsyntax on")

    vim.wo.spell = vim.w.saved_spell or false
    vim.bo.spellcapcheck = vim.w.saved_spellcapcheck or ""
    vim.bo.spellfile = vim.w.saved_spellfile or ""
    vim.bo.spelllang = vim.w.saved_spelllang or "en"

    vim.w[statusline.ownsyntax_flag] = true

    statusline.enable_plugins()
  elseif not active and vim.bo.filetype ~= "" and flag ~= false then
    vim.w.saved_spell = vim.wo.spell
    vim.w.saved_spellcapcheck = vim.bo.spellcapcheck
    vim.w.saved_spellfile = vim.bo.spellfile
    vim.w.saved_spelllang = vim.bo.spelllang

    statusline.disable_plugins()
    vim.cmd("ownsyntax off")

    vim.wo.spell = false
    vim.w[statusline.ownsyntax_flag] = false
  end
end

statusline.should_mkview = function()
  return vim.bo.buftype == ""
    and statusline.mkview_filetype_blacklist[vim.bo.filetype] == nil
    and vim.fn.exists("$SUDO_USER") == 0
end

statusline.set_cursorline = function(active)
  local filetype = vim.bo.filetype
  if statusline.cursorline_blacklist[filetype] ~= true then
    vim.wo.cursorline = active
  end
end

statusline.should_mkview = function()
  return vim.bo.buftype == ""
    and statusline.mkview_filetype_blacklist[vim.bo.filetype] == nil
    and vim.fn.exists("$SUDO_USER") == 0
end

statusline.focus_window = function()
  local filetype = vim.bo.filetype

  if filetype ~= "" and statusline.number_blacklist[filetype] ~= true and vim.w[statusline.number_flag] == nil then
    vim.wo.number = true
    vim.wo.relativenumber = true
  end

  if filetype == "" or statusline.winhighlight_filetype_blacklist[filetype] ~= true then
    vim.wo.winhighlight = ""
  end
  if filetype == "" or statusline.colorcolumn_filetype_blacklist[filetype] ~= true then
    vim.wo.colorcolumn = statusline.focused_colorcolumn
  end
  if filetype == "" or statusline.ownsyntax_filetypes[filetype] ~= true then
    statusline.ownsyntax(true)
  end
  if filetype == "" then
    vim.wo.list = true
  else
    local list = statusline.list_filetypes[filetype]
    vim.wo.list = list == nil and true or list
  end
  local conceallevel = statusline.conceallevel_filetypes[filetype] or 2
  vim.wo.conceallevel = conceallevel
end

statusline.blur_window = function()
  local filetype = vim.bo.filetype

  if filetype ~= "" and statusline.number_blacklist[filetype] ~= true and vim.w[statusline.number_flag] == nil then
    vim.wo.number = true
    vim.wo.relativenumber = false
  end

  if filetype == "" or statusline.winhighlight_filetype_blacklist[filetype] ~= true then
    vim.wo.winhighlight = statusline.winhighlight_blurred
  end
  if filetype == "" or statusline.ownsyntax_filetypes[filetype] ~= true then
    statusline.ownsyntax(false)
  end
  if filetype == "" then
    vim.wo.list = false
  else
    local list = statusline.list_filetypes[filetype]
    if list == nil then
      vim.wo.list = false
    else
      vim.wo.list = list
    end
  end
  if filetype == "" or statusline.conceallevel_filetypes[filetype] == nil then
    vim.wo.conceallevel = 0
  end
end

statusline.mkview = function()
  if statusline.should_mkview() then
    local success, err = pcall(function()
      if vim.fn.haslocaldir() == 1 then
        vim.cmd("cd -")
        vim.cmd("mkview")
        vim.cmd("lcd -")
      else
        vim.cmd("mkview")
      end
    end)
    if not success then
      if
        err:find("%f[%w]E32%f[%W]") == nil
        and err:find("%f[%w]E186%f[%W]") == nil
        and err:find("%f[%w]E190%f[%W]") == nil
        and err:find("%f[%w]E5108%f[%W]") == nil
      then
        error(err)
      end
    end
  end
end
