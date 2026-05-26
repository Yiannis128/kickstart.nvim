-- Sticky function context at top of window
vim.pack.add { 'https://github.com/nvim-treesitter/nvim-treesitter-context' }

require('treesitter-context').setup {
  max_lines = 3,
}
