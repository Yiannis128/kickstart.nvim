-- Start screen / dashboard
vim.pack.add {
  'https://github.com/goolord/alpha-nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
}

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
  dashboard.button('u', '󰚰  Update plugins', '<cmd>lua vim.pack.update()<cr>'),
  dashboard.button('q', '  Quit', '<cmd>qa<cr>'),
}

-- Recent directories section
dashboard.section.recent_dirs = recents.make_section(dashboard, 5)

-- Footer
dashboard.section.footer.val = function()
  local ok, plugins = pcall(vim.pack.get)
  local count = ok and #plugins or 0
  return '⚡ Neovim loaded ' .. count .. ' plugins'
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
