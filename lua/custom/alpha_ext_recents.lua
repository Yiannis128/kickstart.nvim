-- Recent directories extension for alpha-nvim
local M = {}

-- Cache file for recent directories
local cache_file = vim.fn.stdpath('data') .. '/alpha_recent_dirs.txt'

-- Load cached directories from file
local function load_cached_dirs()
  local dirs = {}
  local f = io.open(cache_file, 'r')
  if f then
    for line in f:lines() do
      if line ~= '' and vim.fn.isdirectory(line) == 1 then
        table.insert(dirs, line)
      end
    end
    f:close()
  end
  return dirs
end

-- Save directories to cache file
local function save_cached_dirs(dirs)
  local f = io.open(cache_file, 'w')
  if f then
    for _, dir in ipairs(dirs) do
      f:write(dir .. '\n')
    end
    f:close()
  end
end

-- Get recent directories (from cache + oldfiles)
function M.get_recent_dirs(count)
  local cached = load_cached_dirs()
  local dirs = {}
  local seen = {}

  -- First add cached directories
  for _, dir in ipairs(cached) do
    if not seen[dir] and vim.fn.isdirectory(dir) == 1 then
      seen[dir] = true
      table.insert(dirs, dir)
    end
  end

  -- Fill remaining from oldfiles
  if #dirs < count then
    for _, file in ipairs(vim.v.oldfiles) do
      local dir = vim.fn.fnamemodify(file, ':h')
      if dir ~= '' and dir ~= '.' and not seen[dir] and vim.fn.isdirectory(dir) == 1 then
        seen[dir] = true
        table.insert(dirs, dir)
        if #dirs >= count then
          break
        end
      end
    end
  end

  -- Keep only the requested count
  local result = {}
  for i = 1, math.min(count, #dirs) do
    table.insert(result, dirs[i])
  end

  return result
end

-- Move a directory to the top of the list and save
function M.select_dir(dir)
  local dirs = M.get_recent_dirs(10) -- Get more than we display
  local new_dirs = { dir }
  for _, d in ipairs(dirs) do
    if d ~= dir then
      table.insert(new_dirs, d)
    end
  end
  save_cached_dirs(new_dirs)
  vim.cmd('cd ' .. vim.fn.fnameescape(dir))
  vim.cmd('Alpha')
end

-- Create directory buttons for alpha dashboard
function M.make_buttons(dashboard, count)
  count = count or 5
  local dirs = M.get_recent_dirs(count)
  local buttons = {}

  for i, dir in ipairs(dirs) do
    local short_dir = vim.fn.fnamemodify(dir, ':~') -- Use ~ for home
    local escaped_dir = dir:gsub("'", "''") -- Escape single quotes for Lua string
    local btn = dashboard.button(tostring(i), '  ' .. short_dir, "<cmd>lua require('custom.alpha_ext_recents').select_dir('" .. escaped_dir .. "')<cr>")
    btn.opts.hl = 'AlphaDirButton'
    btn.opts.hl_shortcut = 'AlphaDirShortcut'
    table.insert(buttons, btn)
  end

  return buttons
end

-- Create the recent directories section for alpha
function M.make_section(dashboard, count)
  return {
    type = 'group',
    val = function()
      return {
        { type = 'text', val = '  Recent Directories', opts = { hl = 'AlphaDirHeader', position = 'center' } },
        { type = 'padding', val = 1 },
        { type = 'group', val = function() return M.make_buttons(dashboard, count) end, opts = { spacing = 0 } },
      }
    end,
  }
end

return M
