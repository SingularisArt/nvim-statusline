statusline.file_path = function()
  return vim.fn.expand("%:.")
end

statusline.file_type = function()
  local filetype = vim.bo.filetype
  if #filetype > 0 then
    return table.concat({
      " ",
      "[",
      filetype,
      "]",
    })
  else
    return ""
  end
end
