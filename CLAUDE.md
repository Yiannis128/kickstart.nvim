# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration based on kickstart.nvim - a minimal, single-file starting point for Neovim. The configuration uses lazy.nvim as the plugin manager and is written entirely in Lua.

## Architecture

### Core Structure

- `init.lua` - Main configuration file containing all plugin specs, LSP setup, keymaps, and options
- `lua/custom/init.lua` - Custom initialization for user-specific settings (window resize keymaps, colorcolumn)
- `lua/custom/plugins/init.lua` - Custom plugin definitions (currently barbar.nvim for tab management)
- `lua/kickstart/plugins/` - Optional kickstart plugins (autopairs, debug, gitsigns, indent_line, lint, neo-tree)

### Plugin Management

Plugins are managed via [lazy.nvim](https://github.com/folke/lazy.nvim). All plugin specifications are defined in the `require('lazy').setup({})` call in init.lua:248-1013.

To manage plugins:
- Check plugin status: `:Lazy`
- Update plugins: `:Lazy update`
- Press `?` in the Lazy menu for help

### LSP Configuration

LSP setup uses:
- `nvim-lspconfig` for language server configurations
- `mason.nvim` and `mason-lspconfig.nvim` for automatic LSP installation
- `mason-tool-installer.nvim` for ensuring tools are installed

Currently configured language servers (init.lua:673-701):
- `clangd` (C/C++)
- `gopls` (Go)
- `pyright` (Python)
- `lua_ls` (Lua)

LSP attach handlers and keymaps are defined in the `LspAttach` autocommand (init.lua:525-627).

### Completion

Uses `blink.cmp` for autocompletion with `LuaSnip` for snippets (init.lua:780-877).

Default keymap preset uses `<C-y>` to accept completions.

### Formatting

`conform.nvim` handles code formatting (init.lua:739-778):
- Format manually: `<leader>f`
- Format on save is enabled by default (except for C/C++)
- Currently configured formatter: `stylua` for Lua

Run `:ConformInfo` to check formatter status.

## Code Style

### Lua Formatting

Lua code is formatted with StyLua. Configuration in `.stylua.toml`:
- 160 character column width
- 2 space indentation
- Single quotes preferred
- No call parentheses

Format Lua files: `<leader>f` or let format-on-save handle it.

## Key Concepts

### Leader Key
Leader key is `<space>` (init.lua:90).

### Custom Plugins
Add new plugins in `lua/custom/plugins/init.lua` following the lazy.nvim plugin specification format.

### Custom Settings
Add custom keymaps and vim options in `lua/custom/init.lua`.

### Kickstart Philosophy
This configuration is designed to be read top-to-bottom and understood completely. When making changes, maintain clear comments explaining what code does and why it exists.

## Common Operations

### Adding a New LSP
1. Add server name to the `servers` table in init.lua:673-701
2. Optionally add server-specific settings
3. Mason will auto-install on next startup (or run `:Mason` to install manually)

### Adding a New Plugin
1. Add plugin spec to `lua/custom/plugins/init.lua`
2. Restart Neovim or run `:Lazy sync`

### Checking Health
Run `:checkhealth` to diagnose configuration issues.

### File Navigation
- Find files: `<leader>sf`
- Live grep: `<leader>sg`
- Search help: `<leader>sh`
- Browse buffers: `<leader><leader>`
- File explorer: Use neo-tree (if enabled)

### Buffer/Tab Management (Barbar)
Custom plugin for buffer tabs with these keymaps:
- `<A-Left>` / `<A-Right>` - Switch between buffers
- `<A-Up>` / `<A-Down>` - Move buffer position
- `<A-p>` - Pin buffer
- `<A-x>` - Close buffer

### Window Management
Custom keymaps (lua/custom/init.lua:1-11):
- `<C-Right>` / `<C-Left>` - Adjust window width
- `<C-Up>` / `<C-Down>` - Adjust window height
- `<C-h/j/k/l>` - Navigate between windows

## Dependencies

External tools required:
- `git`, `make`, `unzip`, C compiler (`gcc`)
- `ripgrep` - for live grep functionality
- `fd-find` - for file finding
- Clipboard tool (`xclip`/`xsel` on Linux)
- Nerd Font (optional, enabled via `vim.g.have_nerd_font = true`)

## Notes

- Neovim targets latest stable/nightly versions only
- Configuration expects vim.uv API (Neovim 0.10+)
- Use `:help` and `<space>sh` to search documentation when stuck
