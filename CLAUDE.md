# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Neovim configuration based on kickstart.nvim. Uses `vim.pack` (Neovim's built-in plugin manager) for plugin management. Written entirely in Lua.

## Architecture

### Core Structure

- `init.lua` - Main configuration, organized into numbered `do ... end` sections (options/keymaps, plugin-manager intro, UI plugins, search, LSP, formatting, completion, treesitter, optional examples). Plugins are installed inline with `vim.pack.add { ... }` followed by the plugin's `setup()`. A `gh(repo)` helper builds GitHub URLs. Build steps run via a `PackChanged` autocommand. Kickstart plugins (debug, indent_line, lint, autopairs, neo-tree, gitsigns) and `require 'custom.plugins'` are loaded at the bottom, then `require 'custom.init'`.
- `lua/custom/init.lua` - Custom settings loaded at end of init.lua: window resize keymaps, theming (rose-pine via OSC11 detection), custom commands (`:Ask`, `:Diff`, `:Diffs`, `:ReloadConfig`), colorcolumn, save keymaps, exrc support.
- `lua/custom/plugins/init.lua` - Loader that `require`s every other `.lua` file in the directory. Each sibling file installs/configures one plugin group with `vim.pack.add`: `alpha.lua` (dashboard), `barbar.lua` (tabs), `treesitter-context.lua`, `colorschemes.lua` (+ OSC11), `mason-lspconfig.lua` (auto-enables Mason-installed servers), `notify.lua`.
- `lua/custom/mason.lua` - Centralized Mason tool registry. Single source of truth for LSP servers, formatters, linters, and DAP adapters. Referenced by init.lua for LSP setup and conform.nvim formatter mapping.
- `lua/kickstart/plugins/` - Optional kickstart plugin modules (autopairs, debug, gitsigns, indent_line, lint, neo-tree). Each is a script using `vim.pack.add` (no longer lazy specs).

### Plugins (vim.pack)

- **Add a plugin**: call `vim.pack.add { gh 'owner/repo' }` (or `'https://github.com/owner/repo'`) in the relevant section/file, then call its `setup()`. `vim.pack.add` is synchronous, so `require()` works on the next line.
- **Custom plugins**: drop a new `.lua` file in `lua/custom/plugins/`; the loader picks it up automatically.
- **Update plugins**: `:lua vim.pack.update()` (or the `u` dashboard button). Inspect with `:lua vim.pack.update(nil, { offline = true })`.
- **Build steps** (e.g. telescope-fzf-native `make`, LuaSnip `make install_jsregexp`, treesitter `TSUpdate`) run from the `PackChanged` autocommand in init.lua's section 2.

### LSP Configuration

LSP uses `nvim-lspconfig` + `mason.nvim` + `mason-tool-installer.nvim`. blink.cmp handles capability advertisement internally (no manual `get_lsp_capabilities()` needed).

- **Add an LSP server**: add entry to `lua/custom/mason.lua` `lsp` table, optionally add to `ensure_installed` for auto-install
- **Add a formatter**: add to `formatters_by_ft` in `lua/custom/mason.lua`
- **Add a linter**: add to `linters_by_ft` in `lua/custom/mason.lua`
- Mason-installed servers not in `custom.mason.lsp` are auto-enabled via `mason-lspconfig.nvim` in custom plugins

### Completion

`blink.cmp` with `LuaSnip` for snippets. `<C-y>` accepts completions (default preset).

### Formatting

`conform.nvim` with format-on-save enabled (except C/C++). Manual format: `<leader>f`. Formatter mapping lives in `lua/custom/mason.lua` `formatters_by_ft`. Markdown uses `prettier` (configured via `.prettierrc.json` for `proseWrap: always`), with `markdownlint` as its linter.

## Code Style

Lua formatted with StyLua (`.stylua.toml`): 160 char width, 2-space indent, single quotes, no call parentheses, collapse simple statements.

## Key Mappings

- Leader: `<space>`
- `<C-Right/Left/Up/Down>` - Resize windows
- `<C-h/j/k/l>` - Navigate windows
- `<C-s>` - Save file
- `<A-Left/Right>` - Switch buffers (barbar)
- `<A-Up/Down>` - Move buffer position
- `<A-x>` - Close buffer
- `<leader>sf` - Find files, `<leader>sg` - Live grep, `<leader><leader>` - Buffers
- `<leader>f` - Format buffer
- `<leader>tc` - Colorscheme picker

## Upstream Tracking

This config tracks `upstream` remote (nvim-lua/kickstart.nvim). Merge with `git merge upstream/master`, resolving conflicts to preserve custom additions. Custom files (`lua/custom/*`) don't exist upstream so they won't conflict.

## Dependencies

`git`, `make`, `unzip`, `gcc`, `ripgrep`, `fd-find`, `tree-sitter-cli`, clipboard tool (`xclip`/`xsel`), Nerd Font (enabled). Neovim 0.12+ required (`vim.pack`, treesitter `main` branch).
