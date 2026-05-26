-- You can add your own plugins here or in other files in this directory!
--
-- Each `.lua` file in this directory (other than this one) is loaded
-- automatically. Use `vim.pack.add { ... }` inside them to install plugins,
-- then call the plugin's `setup()` as needed.

-- Iterate over all Lua files in the plugins directory and load them
local plugins_dir = vim.fs.joinpath(vim.fn.stdpath 'config', 'lua', 'custom', 'plugins')
for file_name, type in vim.fs.dir(plugins_dir) do
  if type == 'file' and file_name:match '%.lua$' and file_name ~= 'init.lua' then
    local module = file_name:gsub('%.lua$', '')
    require('custom.plugins.' .. module)
  end
end
