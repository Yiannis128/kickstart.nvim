-- vimtex: LaTeX editing with compile + PDF preview and SyncTeX.
--   Engine : tectonic  (~/.local/bin/tectonic -> ~/AppImages/tectonic)
--   Viewer : zathura   (needs zathura + zathura-pdf-mupdf) - forward + inverse search
-- vimtex is configured through `vim.g.vimtex_*` globals, which must be set
-- BEFORE the plugin is sourced by vim.pack.add.
-- 'zathura_simple' is the Wayland-friendly variant: same forward/inverse search
-- as 'zathura' but without the xdotool (X11-only) window de-duplication.
vim.g.vimtex_compiler_method = 'tectonic'
vim.g.vimtex_view_method = 'zathura_simple'

-- Only surface the quickfix window for real errors, not warnings, while editing.
vim.g.vimtex_quickfix_open_on_warning = 0

-- texlab (LSP, installed via Mason) is the single source of truth for LaTeX
-- completion. Disable vimtex's own completion so it stops registering an
-- omnifunc that would compete with / duplicate texlab's \cite, \ref, etc.
vim.g.vimtex_complete_enabled = 0

-- Silence vimtex's command-line echoes - the ones that stack up into blocking
-- "hit-enter" prompts. Messages are still recorded in :VimtexLog; compile status
-- is surfaced as nvim-notify popups instead (see the User autocmds below).
vim.g.vimtex_log_verbose = 0

vim.pack.add { 'https://github.com/lervag/vimtex' }

local grp = vim.api.nvim_create_augroup('custom_vimtex', { clear = true })

-- In-buffer conceal: render \alpha -> α, math symbols, etc. inline in the source.
vim.api.nvim_create_autocmd('FileType', {
  group = grp,
  pattern = 'tex',
  callback = function() vim.opt_local.conceallevel = 2 end,
})

-- Compile feedback through nvim-notify: a single popup, reused via `replace`, that
-- morphs in place across every compile (save or manual \ll) - no stacking. vimtex
-- fires these User events for each compile, single-shot included.
local notif
local function notify(msg, level, timeout) notif = vim.notify(msg, level, { title = 'LaTeX', timeout = timeout, replace = notif }) end

local compile_events = {
  VimtexEventCompileStarted = { 'Compiling…', vim.log.levels.INFO, false }, -- persists until a result replaces it
  VimtexEventCompileSuccess = { 'Compiled ✓', vim.log.levels.INFO, 2000 },
  VimtexEventCompileFailed = { 'Compilation failed — :VimtexErrors', vim.log.levels.ERROR, 5000 },
}
for event, spec in pairs(compile_events) do
  vim.api.nvim_create_autocmd('User', { group = grp, pattern = event, callback = function() notify(unpack(spec)) end })
end

-- tectonic is single-shot (no continuous mode like latexmk), so recompile on every
-- save to keep the zathura preview fresh. `VimtexCompile!` starts a compile when
-- idle and is a no-op while one is already running. Remove this autocmd to compile
-- manually with \ll instead. (vimtex_view_automatic opens zathura after the first
-- compile; \lv views + forward-searches to the cursor.)
vim.api.nvim_create_autocmd('BufWritePost', {
  group = grp,
  pattern = '*.tex',
  callback = function()
    if vim.b.vimtex ~= nil then vim.cmd 'VimtexCompile!' end
  end,
})
