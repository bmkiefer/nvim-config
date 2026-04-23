# Neovim Config

A minimal, zero-plugin Neovim configuration using native LSP, completion, and diagnostics (Neovim 0.11+). No plugin manager — only built-in Neovim features.

## Directory Structure

```
init.lua                  # Entry point — loads modules in order
lua/config/
  globals.lua             # Leader key and global settings
  options.lua             # Editor options
  keymap.lua              # Key mappings
  autocmd.lua             # Autocommands
  lsp.lua                 # LSP server enablement + completion/diagnostics config
lsp/
  lua_ls.lua              # Lua language server
  pyrefly.lua             # Python language server
  ruff.lua                # Python linter
  ts_ls.lua               # TypeScript/JavaScript language server
  terraform_ls.lua        # Terraform language server
```

## Architecture

Modules are loaded sequentially in `init.lua`:
```
globals → options → keymap → autocmd → lsp
```

LSP servers are configured in individual files under `lsp/` and enabled in `lua/config/lsp.lua` via `vim.lsp.enable()`. See the [Neovim 0.11 LSP overview](https://gpanders.com/blog/whats-new-in-neovim-0-11/) for how this works.

## Adding a New LSP Server

1. Create `lsp/<server_name>.lua` — use `lsp/lua_ls.lua` as a template. Include `cmd`, `filetypes`, `root_markers`, and `settings`.
2. Add `vim.lsp.enable('<server_name>')` to `lua/config/lsp.lua`.

## Conventions

- **Keymaps** → `lua/config/keymap.lua`
- **Options** → `lua/config/options.lua`
- **Autocommands** → `lua/config/autocmd.lua`
- **Leader key** → `<Space>`

## Code Style

Lua is formatted with [StyLua](https://github.com/JohnnyMorganz/StyLua). Config in `.stylua.toml`:
- 160 char line width, 2-space indent, single quotes, Unix line endings

## Git Workflow

- Never commit directly to `master` — always use a feature branch and open a PR
- Branch naming: descriptive kebab-case (e.g. `add-eslint-lsp`)

## Testing / Verification

- `<leader>xx` — source the current file
- `<leader>x` (normal/visual) — execute current line or selection as Lua
- `:checkhealth` — validate LSP and diagnostics setup
