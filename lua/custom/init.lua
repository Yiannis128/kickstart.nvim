-- Resize window vertically larger (increase width)
vim.keymap.set('n', '<C-Right>', '<Cmd>vertical resize +5<CR>', { noremap = true, silent = true, desc = 'Increase window width' })

-- Resize window vertically smaller (decrease width)
vim.keymap.set('n', '<C-Left>', '<Cmd>vertical resize -5<CR>', { noremap = true, silent = true, desc = 'Decrease window width' })

-- Resize window horizontally larger (increase height)
vim.keymap.set('n', '<C-Up>', '<Cmd>resize +3<CR>', { noremap = true, silent = true, desc = 'Increase window height' })

-- Resize window horizontally smaller (decrease height)
vim.keymap.set('n', '<C-Down>', '<Cmd>resize -3<CR>', { noremap = true, silent = true, desc = 'Decrease window height' })

-- Save file with Ctrl+S
vim.keymap.set('n', '<C-s>', '<Cmd>w<CR>', { noremap = true, silent = true, desc = 'Save file' })
vim.keymap.set('i', '<C-s>', '<Esc><Cmd>w<CR>a', { noremap = true, silent = true, desc = 'Save file' })

vim.opt.colorcolumn = '80'
vim.opt.mousescroll = 'ver:1,hor:0'

-- Disable horizontal scrolling in terminal buffers
vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    vim.wo.sidescrolloff = 0
    vim.bo.scrollback = -1
    vim.wo.wrap = true
  end,
})
vim.o.winborder = 'double'

-- Set a light/dark theme. Omit dark theme to just use a constant theme. This
-- function is recommended since it has a nice fallback (tokyonight) in the
-- scenario where an invalid light/dark theme is specified.
local function set_theme(light_theme, dark_theme)
  local function apply_theme(theme)
    local FALLBACK = 'tokyonight'
    local ok, _ = pcall(vim.cmd.colorscheme, theme)
    if not ok then
      vim.cmd.colorscheme(FALLBACK)
      vim.schedule(function()
        vim.notify('Invalid theme specified: ' .. theme .. ' falling back to ' .. FALLBACK, vim.log.levels.WARN, {
          title = 'set_theme command error',
        })
      end)
    end
  end

  -- If no dark theme specified, just use light theme as constant
  if not dark_theme then
    apply_theme(light_theme)
    return
  end

  -- Use OSC11.nvim for automatic terminal theme detection
  require('osc11').setup {
    on_light = function()
      apply_theme(light_theme)
    end,
    on_dark = function()
      apply_theme(dark_theme)
    end,
  }
end

-- Themes - light theme first, optional dark theme second
set_theme('rose-pine-dawn', 'rose-pine-moon')

-- Theme selector (Telescope colorscheme picker with live preview)
vim.keymap.set(
  'n',
  '<leader>tc',
  '<Cmd>Telescope colorscheme enable_preview=true<CR>',
  { noremap = true, silent = true, desc = '[T]heme [C]olorscheme picker' }
)
