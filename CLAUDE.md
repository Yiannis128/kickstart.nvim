# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Neovim configuration based on kickstart.nvim. Uses lazy.nvim for plugin management. Written entirely in Lua.

## Architecture

### Core Structure

- `init.lua` - Main configuration: all base plugin specs, LSP setup, keymaps, vim options. The `require('lazy').setup({})` call contains all plugin specifications. Loaded kickstart plugins (indent_line, lint, autopairs, neo-tree, gitsigns) are enabled at the bottom.
- `lua/custom/init.lua` - Custom settings loaded at end of init.lua: window resize keymaps, theming (rose-pine via OSC11 detection), custom commands (`:Ask`, `:Diff`, `:Diffs`), colorcolumn, save keymaps, exrc support.
- `lua/custom/plugins/init.lua` - Custom plugin definitions: alpha-nvim dashboard, barbar tabs, treesitter-context, colorschemes, mason-lspconfig (auto-enables Mason-installed servers), vim-sleuth, nvim-notify.
- `lua/custom/mason.lua` - Centralized Mason tool registry. Single source of truth for LSP servers, formatters, linters, and DAP adapters. Referenced by init.lua for LSP setup and conform.nvim formatter mapping.
- `lua/kickstart/plugins/` - Optional kickstart plugin modules (autopairs, debug, gitsigns, indent_line, lint, neo-tree).

### LSP Configuration

LSP uses `nvim-lspconfig` + `mason.nvim` + `mason-tool-installer.nvim`. blink.cmp handles capability advertisement internally (no manual `get_lsp_capabilities()` needed).

- **Add an LSP server**: add entry to `lua/custom/mason.lua` `lsp` table, optionally add to `ensure_installed` for auto-install
- **Add a formatter**: add to `formatters_by_ft` in `lua/custom/mason.lua`
- **Add a linter**: add to `linters_by_ft` in `lua/custom/mason.lua`
- Mason-installed servers not in `custom.mason.lsp` are auto-enabled via `mason-lspconfig.nvim` in custom plugins

### Completion

`blink.cmp` with `LuaSnip` for snippets. `<C-y>` accepts completions (default preset).

### Formatting

`conform.nvim` with format-on-save enabled (except C/C++). Manual format: `<leader>f`. Formatter mapping lives in `lua/custom/mason.lua` `formatters_by_ft`.

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

`git`, `make`, `unzip`, `gcc`, `ripgrep`, `fd-find`, `tree-sitter-cli`, clipboard tool (`xclip`/`xsel`), Nerd Font (enabled). Neovim 0.10+ required (vim.uv API).
