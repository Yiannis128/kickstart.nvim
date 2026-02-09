-- Centralized Mason tool definitions.
-- All tools managed by Mason are declared here so that a single file
-- controls what gets installed and how tools map to filetypes.

return {
  -- LSP servers: keys are server names (auto-installed by mason-tool-installer),
  -- values are server-specific config passed to lspconfig.
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

  -- Formatter Mason package names to install.
  fmt = {
    'stylua',
    'prettier',
    'black',
  },

  -- Filetype -> formatter mapping (passed to conform.nvim).
  -- Tools here that aren't Mason packages (e.g. pyproject_fmt) don't
  -- need to be in the fmt list above.
  formatters_by_ft = {
    lua = { 'stylua' },
    markdown = { 'prettier' },
    python = { 'black' },
    toml = { 'pyproject_fmt' },
  },

  -- DAP adapter Mason package names to install.
  dap = {},

  -- Linter Mason package names to install.
  linter = {
    'markdownlint',
  },

  -- Filetype -> linter mapping (passed to nvim-lint).
  linters_by_ft = {
    markdown = { 'markdownlint' },
  },
}
