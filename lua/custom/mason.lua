-- Centralized Mason tool definitions.
-- All tools managed by Mason are declared here so that a single file
-- controls what gets installed and how tools map to filetypes.

return {
  -- LSP servers: keys are lspconfig server names,
  -- values are server-specific config passed to vim.lsp.config().
  lsp = {
    lua_ls = {
      settings = {
        Lua = {
          completion = {
            callSnippet = 'Replace',
          },
        },
      },
    },
  },

  -- Filetype -> formatter mapping (passed to conform.nvim).
  formatters_by_ft = {
    lua = { 'stylua' },
    markdown = { 'prettier' },
    python = { 'black' },
    toml = { 'pyproject_fmt' },
  },

  -- Filetype -> linter mapping (passed to nvim-lint).
  linters_by_ft = {
    markdown = { 'markdownlint' },
  },

  -- DAP adapter Mason package names to install.
  dap = {},

  -- Mason packages to auto-install (uses Mason registry names).
  -- Leave empty to manage installations manually via :Mason UI.
  ensure_installed = {
    -- LSP servers
    -- Formatters
    -- Linters
    -- DAP adapters
  },
}
