statusline.chs = function()
  local modified = ""
  if vim.bo.modified then
    modified = " ✘"
  end

  return table.concat({
    statusline.file_path(),
    statusline.file_type(),
    modified,
  })
end
