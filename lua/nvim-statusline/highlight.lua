statusline.update_highlight = function(status_highlight)
  local pinnacle = require("wincent.pinnacle")

  -- Update StatusLine to use italics (used for filetype).
  local highlight = pinnacle.italicize("StatusLine")
  vim.cmd("highlight User1 " .. highlight)

  -- Update MatchParen to use italics (used for blurred statuslines).
  highlight = pinnacle.italicize("MatchParen")
  vim.cmd("highlight User2 " .. highlight)

  -- StatusLine + bold (used for file names).
  highlight = pinnacle.embolden("StatusLine")
  vim.cmd("highlight User3 " .. highlight)

  -- Inverted Error styling, for left-hand side "Powerline" triangle.
  local fg = pinnacle.extract_fg(status_highlight)
  local bg = pinnacle.extract_bg("StatusLine")
  vim.cmd("highlight User4 " .. pinnacle.highlight({ bg = bg, fg = fg }))

  -- And opposite for the buffer number area.
  vim.cmd("highlight User7 " .. pinnacle.highlight({
    bg = fg,
    fg = pinnacle.extract_fg("Normal"),
    term = "bold",
  }))

  -- Right-hand side section.
  bg = pinnacle.extract_fg("Cursor")
  fg = pinnacle.extract_fg("User3")
  vim.cmd("highlight User5 " .. pinnacle.highlight({
    bg = fg,
    fg = bg,
    term = "bold",
  }))

  -- Right-hand side section + italic (used for %).
  vim.cmd("highlight User6 " .. pinnacle.highlight({
    bg = fg,
    fg = bg,
    term = "bold,italic",
  }))

  vim.cmd("highlight clear StatusLineNC")
  vim.cmd("highlight! link StatusLineNC User1")
end
