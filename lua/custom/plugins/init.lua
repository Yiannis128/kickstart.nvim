-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VimEnter',
    config = function()
      local alpha = require 'alpha'
      local dashboard = require 'alpha.themes.dashboard'
      local recents = require 'custom.alpha_ext_recents'

      -- Load ASCII art header from file
      local function load_splash()
        local splash_path = vim.fn.stdpath 'config' .. '/lua/custom/alpha_splash.txt'
        local lines = {}
        local f = io.open(splash_path, 'r')
        if f then
          for line in f:lines() do
            table.insert(lines, line)
          end
          f:close()
        end
        return lines
      end
      dashboard.section.header.val = load_splash()

      -- Menu buttons
      dashboard.section.buttons.val = {
        dashboard.button('f', '󰈞  Find file', '<cmd>Telescope find_files<cr>'),
        dashboard.button('n', '  New file', '<cmd>ene <BAR> startinsert<cr>'),
        dashboard.button('r', '󰊄  Recent files', '<cmd>Telescope oldfiles<cr>'),
        dashboard.button('g', '󰈬  Find word', '<cmd>Telescope live_grep<cr>'),
        dashboard.button('c', '  Configuration', '<cmd>e $MYVIMRC<cr>'),
        dashboard.button('l', '󰒲  Lazy', '<cmd>Lazy<cr>'),
        dashboard.button('q', '  Quit', '<cmd>qa<cr>'),
      }

      -- Recent directories section
      dashboard.section.recent_dirs = recents.make_section(dashboard, 5)

      -- Footer
      dashboard.section.footer.val = function()
        local stats = require('lazy').stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        return '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms'
      end

      -- Styling
      dashboard.section.header.opts.hl = 'AlphaHeader'
      dashboard.section.buttons.opts.hl = 'AlphaButtons'
      dashboard.section.footer.opts.hl = 'AlphaFooter'

      -- Layout
      dashboard.config.layout = {
        { type = 'padding', val = 2 },
        dashboard.section.header,
        { type = 'padding', val = 2 },
        dashboard.section.buttons,
        { type = 'padding', val = 2 },
        dashboard.section.recent_dirs,
        { type = 'padding', val = 1 },
        dashboard.section.footer,
      }

      -- Highlight colors
      vim.api.nvim_set_hl(0, 'AlphaHeader', { fg = '#6272a4' })
      vim.api.nvim_set_hl(0, 'AlphaButtons', { fg = '#f8f8f2' })
      vim.api.nvim_set_hl(0, 'AlphaFooter', { fg = '#6272a4', italic = true })
      vim.api.nvim_set_hl(0, 'AlphaDirHeader', { fg = '#bd93f9', bold = true })
      vim.api.nvim_set_hl(0, 'AlphaDirButton', { fg = '#8be9fd' })
      vim.api.nvim_set_hl(0, 'AlphaDirShortcut', { fg = '#ffb86c' })

      alpha.setup(dashboard.config)

      -- Disable folding on alpha buffer
      vim.cmd [[autocmd FileType alpha setlocal nofoldenable]]
    end,
  },
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      animation = true,
      insert_at_start = false,
    },
    version = '^1.0.0',
    config = function(_, opts)
      require('barbar').setup(opts)
      -- Keymaps for Barbar
      vim.keymap.set('n', '<A-Left>', '<Cmd>BufferPrevious<CR>', { noremap = true, silent = true, desc = 'Switch to previous tab.' })
      vim.keymap.set('n', '<A-Right>', '<Cmd>BufferNext<CR>', { noremap = true, silent = true, desc = 'Switch to next tab.' })
      vim.keymap.set('n', '<A-Up>', '<Cmd>BufferMovePrevious<CR>', { noremap = true, silent = true, desc = 'Move buffer left.' })
      vim.keymap.set('n', '<A-Down>', '<Cmd>BufferMoveNext<CR>', { noremap = true, silent = true, desc = 'Move buffer right.' })
      vim.keymap.set('n', '<A-p>', '<Cmd>BufferPin<CR>', { noremap = true, silent = true, desc = 'Pin buffer.' })
      vim.keymap.set('n', '<A-x>', '<Cmd>BufferClose<CR>', { noremap = true, silent = true, desc = 'Close buffer.' })
      vim.keymap.set('n', '<A-S-x>', '<Cmd>BufferClose!<CR>', { noremap = true, silent = true, desc = 'Force close buffer.' })
    end,
  },

  -- Sticky function context at top of window
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      max_lines = 3,
    },
  },

  -- Colorschemes (lazy-loaded, use :colorscheme <name> to activate)
  { 'folke/tokyonight.nvim', name = 'tokyonight', lazy = true },
  { 'catppuccin/nvim', name = 'catppuccin', lazy = true },
  { 'rebelot/kanagawa.nvim', lazy = true },
  { 'rose-pine/neovim', name = 'rose-pine', lazy = true },
  { 'EdenEast/nightfox.nvim', lazy = true },
  { 'navarasu/onedark.nvim', lazy = true },
  { 'sainnhe/gruvbox-material', lazy = true },
  { 'sainnhe/everforest', lazy = true },
  { 'projekt0n/github-nvim-theme', lazy = true },

  -- OSC 11 terminal theme detection
  { 'afonsofrancof/OSC11.nvim', lazy = true },

  -- Auto-detect indentation style from buffer content
  { 'tpope/vim-sleuth' },

  -- Notification UI
  {
    'rcarriga/nvim-notify',
    config = function()
      local notify = require 'notify'
      notify.setup {
        stages = 'fade_in_slide_out',
        timeout = 3000,
      }
      vim.notify = notify
    end,
  },
}
