statusline.lhs = function()
  local icons = require("config.global").icons.git
  -- local padding = statusline.gutterpadding()

  local git_info = vim.b.gitsigns_status_dict
  if not git_info or git_info.head == "" then
    return ""
  end

  local added = git_info.added and (icons.Add .. git_info.added .. " ") or ""
  local changed = git_info.changed and (icons.Mod .. git_info.changed .. " ") or ""
  local removed = git_info.removed and (icons.Remove .. git_info.removed .. " ") or ""

  if git_info.added == 0 then
    added = ""
  end
  if git_info.changed == 0 then
    changed = ""
  end
  if git_info.removed == 0 then
    removed = ""
  end

  return table.concat({
    icons.Repo,
    git_info.head,
    " ",
    added,
    changed,
    removed,
    -- padding,
  })
end
