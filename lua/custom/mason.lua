-- Centralized Mason tool definitions.
-- All tools managed by Mason are declared here so that a single file
-- controls what gets installed and how tools map to filetypes.

return {
  -- LSP servers: keys are lspconfig server names,
  -- values are server-specific config passed to vim.lsp.config().
  -- All but lua_ls come from the system PATH; they need an entry here because
  -- mason-lspconfig only auto-enables servers Mason itself installed.
  lsp = {
    bashls = {},
    clangd = {},
    pyright = {},
    texlab = {},
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
  -- These are resolved from the system PATH, not Mason. See `ensure_installed`.
  formatters_by_ft = {
    lua = { 'stylua' },
    markdown = { 'prettier' },
    python = { 'ruff_format' },
    tex = { 'tex-fmt' },
    c = { 'clang-format' },
    cpp = { 'clang-format' },
  },

  -- Filetype -> linter mapping (passed to nvim-lint).
  linters_by_ft = {
    markdown = { 'markdownlint' },
  },

  -- Mason packages to auto-install (uses Mason registry names).
  -- Only what no other package manager ships. Everything else lives on the
  -- system PATH so tools outside nvim run the same binaries.
  ensure_installed = {
    'lua-language-server',
  },
}
