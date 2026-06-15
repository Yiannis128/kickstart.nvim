-- Configures lua_ls for editing your Neovim config, runtime and plugins.
-- It dynamically feeds the Neovim runtime (and installed plugins) to lua_ls as
-- a workspace library, which defines the `vim` global (fixing "undefined
-- global `vim`" warnings) and provides completion, annotations and signatures
-- for the Neovim API. The blink.cmp `lazydev` source — for completing `require`
-- module paths — is registered in init.lua's autocomplete section.
vim.pack.add { 'https://github.com/folke/lazydev.nvim' }

require('lazydev').setup {
  library = {
    -- Load luvit types when the `vim.uv` word is found
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}
