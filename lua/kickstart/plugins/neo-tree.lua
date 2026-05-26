-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

local plugins = {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

if vim.g.have_nerd_font then
  table.insert(plugins, 'https://github.com/nvim-tree/nvim-web-devicons') -- not strictly required, but recommended
end

vim.pack.add(plugins)

vim.keymap.set('n', '\\', function()
  local ok, err = pcall(vim.cmd, 'Neotree reveal')
  if not ok then vim.notify('Neo-tree: No file to reveal (empty buffer)\n' .. err, vim.log.levels.INFO) end
end, { desc = 'NeoTree reveal', silent = true })

require('neo-tree').setup {
  open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
  filesystem = {
    window = {
      mappings = {
        ['\\'] = 'close_window',
      },
    },
  },
}
