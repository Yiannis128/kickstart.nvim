-- Auto-enable Mason-installed LSP servers that aren't explicitly configured
-- in `lua/custom/mason.lua` (those are enabled directly in init.lua via
-- vim.lsp.config/enable). The plugin itself is added in init.lua's LSP section.
require('mason-lspconfig').setup {
  automatic_enable = {
    exclude = vim.tbl_keys(require('custom.mason').lsp),
  },
}
