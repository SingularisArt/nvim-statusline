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

    local attached_clients = statusline.get_attached_clients()

    rhs = rhs .. attached_clients
    rhs = rhs .. " "
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
