-- In-buffer markdown rendering (headings, code blocks, tables, checkboxes,
-- callouts) drawn live as you edit. Pure-terminal; no external viewer.
-- Relies on the `markdown` + `markdown_inline` treesitter parsers (already in
-- init.lua's parser list) and nvim-web-devicons for icons.
vim.pack.add { 'https://github.com/MeanderingProgrammer/render-markdown.nvim' }

require('render-markdown').setup {
  -- Render in normal/command/terminal modes; show raw source while editing a line in insert/visual.
  render_modes = { 'n', 'c', 't' },
  file_types = { 'markdown' },
}

-- Toggle inline rendering on/off.
vim.keymap.set('n', '<leader>tm', '<Cmd>RenderMarkdown toggle<CR>', { desc = '[T]oggle [M]arkdown rendering' })
