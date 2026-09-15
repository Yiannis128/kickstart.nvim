# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Neovim configuration based on kickstart.nvim. Uses `vim.pack` (Neovim's built-in plugin manager) for plugin management. Written entirely in Lua.

## Architecture

### Core Structure

- `init.lua` - Main configuration, organized into numbered `do ... end` sections (options/keymaps, plugin-manager intro, UI plugins, search, LSP, formatting, completion, treesitter, optional examples). Plugins are installed inline with `vim.pack.add { ... }` followed by the plugin's `setup()`. A `gh(repo)` helper builds GitHub URLs. Build steps run via a `PackChanged` autocommand. Kickstart plugins (debug, indent_line, lint, autopairs, neo-tree, gitsigns) and `require 'custom.plugins'` are loaded at the bottom, then `require 'custom.init'`.
- `lua/custom/init.lua` - Custom settings loaded at end of init.lua: window resize keymaps, theming (rose-pine via OSC11 detection), custom commands (`:Ask`, `:Diff`, `:Diffs`, `:ReloadConfig`), colorcolumn, save keymaps, exrc support.
- `lua/custom/plugins/init.lua` - Loader that `require`s every other `.lua` file in the directory. Each sibling file installs/configures one plugin group with `vim.pack.add`: `alpha.lua` (dashboard), `barbar.lua` (tabs), `treesitter-context.lua`, `colorschemes.lua` (+ OSC11), `mason-lspconfig.lua` (auto-enables Mason-installed servers), `notify.lua`.
- `lua/custom/mason.lua` - Central tool registry. Single source of truth for LSP servers, formatters and linters. Referenced by init.lua for LSP setup and conform.nvim formatter mapping. Despite the name, most of what it maps is installed outside Mason — see Tooling below.
- `lua/kickstart/plugins/` - Optional kickstart plugin modules (autopairs, debug, gitsigns, indent_line, lint, neo-tree). Each is a script using `vim.pack.add` (no longer lazy specs).

### Plugins (vim.pack)

- **Add a plugin**: call `vim.pack.add { gh 'owner/repo' }` (or `'https://github.com/owner/repo'`) in the relevant section/file, then call its `setup()`. `vim.pack.add` is synchronous, so `require()` works on the next line.
- **Custom plugins**: drop a new `.lua` file in `lua/custom/plugins/`; the loader picks it up automatically.
- **Update plugins**: `:lua vim.pack.update()` (or the `u` dashboard button). Inspect with `:lua vim.pack.update(nil, { offline = true })`.
- **Build steps** (e.g. telescope-fzf-native `make`, LuaSnip `make install_jsregexp`, treesitter `TSUpdate`) run from the `PackChanged` autocommand in init.lua's section 2.

### Tooling — where formatters, linters and LSP servers come from

Mason is set up with `PATH = 'append'`, so a tool on the system PATH always beats a Mason copy. This is deliberate. Mason's `bin/` is injected into nvim's process PATH only, so anything installed there is invisible to shells, scripts, CI and coding agents — they cannot format or lint with it. Install through the manager that owns the language and nvim picks it up automatically, since `conform.nvim` and `nvim-lint` resolve executables from PATH.

| tool | installed with |
| --- | --- |
| `ruff`, `clang-format`, `clangd` | `dnfkeep add base "<why>" <pkg>` |
| `stylua`, `tex-fmt`, `texlab` | `cargo install` |
| `prettier`, `markdownlint`, `bash-language-server`, `pyright` | `bun install -g` |
| Python CLI tools | `uv tool install` |
| `lua-language-server` | Mason — packaged nowhere else |

**Mason is the last resort, not the default.** `ensure_installed` lists only what no other manager ships. Adding anything else there silently duplicates a system package: it happened with `clangd`, which `clang-tools-extra` already provides.

Project-specific toolchains do not go on the host at all. They belong to that project's toolbox container — declared in `~/.config/dnfkeep/containers/<name>.keep`, installed by the container's own dnf through `~/.config/toolbox/Containerfile.<name>`. `$HOME` is bind-mounted into every toolbox, so this config *and* `~/.local/share/nvim/mason` are shared between host and containers, which is precisely why anything compiled must come from the container's dnf rather than Mason. `lldb-dap` is the worked example: a debugger has to run in the same context as the build.

### LSP Configuration

LSP uses `nvim-lspconfig` + `mason.nvim` + `mason-tool-installer.nvim`. blink.cmp handles capability advertisement internally (no manual `get_lsp_capabilities()` needed).

- **Add an LSP server**: install it per the table above, then add an entry (even `{}`) to the `lsp` table in `lua/custom/mason.lua` — `mason-lspconfig` only auto-enables servers Mason itself installed, so a PATH-provided server is never enabled without one
- **Add a formatter**: add to `formatters_by_ft` in `lua/custom/mason.lua`
- **Add a linter**: add to `linters_by_ft` in `lua/custom/mason.lua`
- **Add a DAP adapter**: configure `dap.adapters.*` directly in `lua/kickstart/plugins/debug.lua` with a bare command name so it resolves from PATH

### Completion

`blink.cmp` with `LuaSnip` for snippets. `<C-y>` accepts completions (default preset).

### Formatting

`conform.nvim` with format-on-save for every filetype — `disable_filetypes` is empty, the `{ c = true, cpp = true }` beside it is a commented-out example. Manual format: `<leader>f`. Formatter mapping lives in `lua/custom/mason.lua` `formatters_by_ft`. Python uses `ruff_format` (not black). Markdown uses `prettier`, with `markdownlint` as its linter; prose wrapping is set twice, in `.prettierrc.json` and again as `prepend_args` in init.lua. C/C++ use `clang-format` with no style overrides, so a project `.clang-format` applies and LLVM style is the fallback.

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
