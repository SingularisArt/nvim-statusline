require("nvim-statusline.autocmds.variables")
require("nvim-statusline.autocmds.functions")

vim.api.nvim_create_augroup("Autocmds", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  group = "Autocmds",
  callback = statusline.focus_window,
})

vim.api.nvim_create_autocmd("BufLeave", {
  group = "Autocmds",
  callback = statusline.mkview,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = "Autocmds",
  callback = function ()
    if statusline.should_mkview() then
      vim.cmd("silent! loadview")
      vim.cmd("silent! " .. vim.fn.line(".") .. "foldopen!")
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = "Autocmds",
  callback = statusline.mkview,
})

vim.api.nvim_create_autocmd("FocusGained", {
  group = "Autocmds",
  callback = statusline.focus_window,
})

vim.api.nvim_create_autocmd("FocusLost", {
  group = "Autocmds",
  callback = statusline.blur_window,
})

vim.api.nvim_create_autocmd("InsertEnter", {
  group = "Autocmds",
  callback = function()
    statusline.set_cursorline(false)
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = "Autocmds",
  callback = function()
    statusline.set_cursorline(true)
    vim.opt.paste = false
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = "Autocmds",
  command = "silent! lua vim.highlight.on_yank {higroup='Substitute', timeout=100}",
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = "Autocmds",
  callback = function()
    statusline.set_cursorline(true)
    statusline.focus_window()
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = "Autocmds",
  command = "execute 'normal! \\<c-w>='",
})

vim.api.nvim_create_autocmd("WinEnter", {
  group = "Autocmds",
  callback = function()
    statusline.set_cursorline(true)
    statusline.focus_window()
  end,
})

vim.api.nvim_create_autocmd("WinLeave", {
  group = "Autocmds",
  callback = function()
    statusline.set_cursorline(false)
    statusline.blur_window()
  end,
})
