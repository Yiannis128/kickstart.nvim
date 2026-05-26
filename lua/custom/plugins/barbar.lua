-- Tabline / buffer bar
-- Disable barbar's automatic setup so we control initialization order.
vim.g.barbar_auto_setup = false

vim.pack.add {
  -- Dependencies (gitsigns and web-devicons are also added elsewhere; harmless to list)
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  { src = 'https://github.com/romgrk/barbar.nvim', version = vim.version.range '1.*' },
}

require('barbar').setup {
  animation = true,
  insert_at_start = false,
}

-- Keymaps for barbar
vim.keymap.set('n', '<A-Left>', '<Cmd>BufferPrevious<CR>', { noremap = true, silent = true, desc = 'Switch to previous tab.' })
vim.keymap.set('n', '<A-Right>', '<Cmd>BufferNext<CR>', { noremap = true, silent = true, desc = 'Switch to next tab.' })
vim.keymap.set('n', '<A-Up>', '<Cmd>BufferMovePrevious<CR>', { noremap = true, silent = true, desc = 'Move buffer left.' })
vim.keymap.set('n', '<A-Down>', '<Cmd>BufferMoveNext<CR>', { noremap = true, silent = true, desc = 'Move buffer right.' })
vim.keymap.set('n', '<A-p>', '<Cmd>BufferPin<CR>', { noremap = true, silent = true, desc = 'Pin buffer.' })
vim.keymap.set('n', '<A-x>', '<Cmd>BufferClose<CR>', { noremap = true, silent = true, desc = 'Close buffer.' })
vim.keymap.set('n', '<A-S-x>', '<Cmd>BufferClose!<CR>', { noremap = true, silent = true, desc = 'Force close buffer.' })
