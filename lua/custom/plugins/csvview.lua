-- CSV/TSV viewer: aligns columns into a table view
vim.pack.add { 'https://github.com/hat0uma/csvview.nvim' }

require('csvview').setup {
  parser = { comments = { '#', '//' } },
  view = {
    display_mode = 'border',
  },
  keymaps = {
    -- Text objects for selecting fields
    textobject_field_inner = { 'if', mode = { 'o', 'x' } },
    textobject_field_outer = { 'af', mode = { 'o', 'x' } },
    -- Navigate between fields
    jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
    jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
    jump_next_row = { '<Enter>', mode = { 'n', 'v' } },
    jump_prev_row = { '<S-Enter>', mode = { 'n', 'v' } },
  },
}

-- Toggle the aligned CSV view in a given display mode.
-- Pressing the same mode's key again turns the view off; pressing the other
-- mode's key while the view is on switches to that mode (csvview.enable() is a
-- no-op when already enabled, so we disable first to actually swap modes).
local csvview = require 'csvview'
local function toggle_mode(mode)
  return function()
    local bufnr = vim.api.nvim_get_current_buf()
    if not csvview.is_enabled(bufnr) then
      csvview.enable(bufnr, { view = { display_mode = mode } })
      vim.b[bufnr].csvview_mode = mode
    elseif vim.b[bufnr].csvview_mode == mode then
      csvview.disable(bufnr)
      vim.b[bufnr].csvview_mode = nil
    else
      csvview.disable(bufnr)
      csvview.enable(bufnr, { view = { display_mode = mode } })
      vim.b[bufnr].csvview_mode = mode
    end
  end
end

vim.keymap.set('n', '<leader>tvv', toggle_mode 'border', { desc = '[T]oggle CSV [V]iew (border)' })
vim.keymap.set('n', '<leader>tvc', toggle_mode 'highlight', { desc = '[T]oggle CSV view ([c]olor/highlight)' })
