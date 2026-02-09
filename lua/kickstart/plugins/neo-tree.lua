-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    {
      '\\',
      function()
        local ok, err = pcall(vim.cmd, 'Neotree reveal')
        if not ok then
          vim.notify('Neo-tree: No file to reveal (empty buffer)\n' .. err, vim.log.levels.INFO)
        end
      end,
      desc = 'NeoTree reveal',
      silent = true,
    },
  },
  opts = {
    open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
