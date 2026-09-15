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

-- Switch between source and header files (clangd)
vim.keymap.set('n', 'grs', '<Cmd>LspClangdSwitchSourceHeader<CR>', { desc = '[G]o [R]elated [S]ource' })

vim.opt.colorcolumn = '80'
vim.opt.mousescroll = 'ver:2,hor:0'

-- Spaces, not tabs, so conform's tex-fmt runs `--tabsize 2` without --usetabs
vim.o.expandtab = true
vim.o.shiftwidth = 2

-- Remove the "How-to disable mouse" entry (and its now-dangling separator) from
-- the right-click popup menu. These are Neovim default PopUp items; see
-- runtime/lua/vim/_defaults.lua and :help vim_diff (aunmenu PopUp...).
pcall(vim.cmd, [[aunmenu PopUp.How-to\ disable\ mouse]])
pcall(vim.cmd, [[aunmenu PopUp.-2-]])

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
      vim.schedule(
        function()
          vim.notify('Invalid theme specified: ' .. theme .. ' falling back to ' .. FALLBACK, vim.log.levels.WARN, {
            title = 'set_theme command error',
          })
        end
      )
    end
  end

  -- If no dark theme specified, just use light theme as constant
  if not dark_theme then
    apply_theme(light_theme)
    return
  end

  -- Use OSC11.nvim for automatic terminal theme detection.
  -- OSC11 is passive: it only listens for OSC 11 responses (via a TermResponse
  -- autocmd) and never queries the terminal itself. It relies on overhearing
  -- the response to the query Neovim fires once at startup. That response is
  -- async, so if it arrives before this listener is registered it is missed
  -- and no theme is applied (the "random" failure).
  require('osc11').setup {
    on_light = function() apply_theme(light_theme) end,
    on_dark = function() apply_theme(dark_theme) end,
  }

  -- Proactively re-query the terminal for its background color. This guarantees
  -- a fresh OSC 11 response arrives *after* the listener above is registered,
  -- so OSC11 reliably applies the correct light/dark theme regardless of how
  -- the startup response raced against plugin load order.
  io.write '\027]11;?\007'
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

-- Reload the Neovim config without restarting.
-- Clears cached custom/kickstart Lua modules so edits under lua/ are picked up,
-- then re-sources init.lua.
vim.api.nvim_create_user_command('ReloadConfig', function()
  for name in pairs(package.loaded) do
    if name:match '^custom' or name:match '^kickstart' then package.loaded[name] = nil end
  end
  vim.cmd('source ' .. vim.fn.stdpath 'config' .. '/init.lua')
  vim.notify('Config reloaded', vim.log.levels.INFO, { title = 'ReloadConfig' })
end, { desc = 'Reload Neovim config' })

-- Git diff with delta
vim.api.nvim_create_user_command('Diff', function() vim.cmd 'term git diff | delta' end, { desc = 'Git diff with delta' })

vim.api.nvim_create_user_command('Diffs', function() vim.cmd 'term git diff | delta --side-by-side' end, { desc = 'Git diff with delta (side-by-side)' })

-- Ask Claude a question from within Neovim
vim.api.nvim_create_user_command('Ask', function(opts)
  local question = opts.args
  if question == '' then
    vim.notify('Usage: :Ask <question>', vim.log.levels.ERROR)
    return
  end
  local nvim_dir = vim.fn.stdpath 'config'
  vim.notify('Asking Claude...', vim.log.levels.INFO, { title = 'Claude' })
  vim.system({ 'claude', '-p', question }, { cwd = nvim_dir }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        vim.notify('Claude error (exit code ' .. result.code .. ')', vim.log.levels.ERROR, { title = 'Claude' })
        return
      end
      local output = vim.trim(result.stdout)
      local lines = vim.split(output, '\n')
      if #lines <= 5 then
        vim.notify(output, vim.log.levels.INFO, { title = 'Claude', timeout = 20000 })
      else
        vim.cmd 'vnew'
        local buf = vim.api.nvim_get_current_buf()
        vim.bo[buf].buftype = 'nofile'
        vim.bo[buf].bufhidden = 'wipe'
        vim.bo[buf].swapfile = false
        vim.bo[buf].filetype = 'markdown'
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      end
    end)
  end)
end, { nargs = '+', desc = 'Ask Claude a question' })

-- Project-local hook for .nvim.lua files (vim.o.exrc): makes dotfiles except
-- .git visible in telescope find_files/live_grep and neo-tree. The optional
-- list restricts both pickers to those search roots. Usage:
--   add_directory { 'zsh', 'git' }   -- or add_directory()
function _G.add_directory(dirs)
  dirs = dirs or {}

  local telescope_ok, telescope = pcall(require, 'telescope')
  if telescope_ok then
    -- find_command is the only supported exclude mechanism on find_files'
    -- rg path (no additional_args there); rg is a hard dep of this config
    local find_command = { 'rg', '--files', '--hidden', '--color', 'never', '-g', '!.git' }
    vim.list_extend(find_command, dirs)
    telescope.setup {
      pickers = {
        find_files = { find_command = find_command },
        live_grep = { hidden = true, additional_args = { '-g', '!.git' }, search_dirs = dirs },
      },
    }
  end

  local neotree_ok, neotree = pcall(require, 'neo-tree')
  if neotree_ok then
    -- setup() only stashes config until the tree first opens (neotree.config
    -- is nil before that), so extend the pending user config from peek_config
    -- instead of the merged one; merge_config re-merges against defaults
    neotree.setup(vim.tbl_deep_extend('force', neotree.peek_config() or {}, {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          never_show = { '.git' },
        },
      },
    }))
  end
end

-- Source project-local .nvim.lua from the current directory (with trust prompt)
vim.o.exrc = true
