-- Colorschemes (installed and available via `:colorscheme <name>`).
-- The active theme is selected in `lua/custom/init.lua` (OSC11 light/dark
-- detection). `:Telescope colorscheme` (mapped to <leader>tc) previews them.
vim.pack.add {
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/catppuccin/nvim',
  'https://github.com/rebelot/kanagawa.nvim',
  'https://github.com/rose-pine/neovim',
  'https://github.com/EdenEast/nightfox.nvim',
  'https://github.com/navarasu/onedark.nvim',
  'https://github.com/sainnhe/gruvbox-material',
  'https://github.com/sainnhe/everforest',
  'https://github.com/projekt0n/github-nvim-theme',

  -- OSC 11 terminal background detection (used by custom.init for theming)
  'https://github.com/afonsofrancof/OSC11.nvim',
}
