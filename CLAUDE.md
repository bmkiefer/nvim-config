# Neovim Config

A minimal Neovim configuration using native LSP, completion, and diagnostics (Neovim 0.11+). Plugins are managed via the built-in `vim.pack.add()` API — no external plugin manager.

## Directory Structure

```
init.lua                  # Entry point — loads modules in order
nvim-pack-lock.json       # Lockfile pinning installed plugin revisions
lua/config/
  globals.lua             # Leader key and global settings
  plugins.lua             # Plugin declarations via vim.pack.add
  theme.lua               # Colorscheme configuration
  options.lua             # Editor options
  keymap.lua              # Key mappings
  gitlink.lua             # GitHub permalink generation
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
globals → plugins → theme → options → keymap → gitlink → autocmd → lsp
```

LSP servers are configured in individual files under `lsp/` and enabled in `lua/config/lsp.lua` via `vim.lsp.enable()`. See the [Neovim 0.11 LSP overview](https://gpanders.com/blog/whats-new-in-neovim-0-11/) for how this works.

## Adding a New LSP Server

1. Create `lsp/<server_name>.lua` — use `lsp/lua_ls.lua` as a template. Include `cmd`, `filetypes`, `root_markers`, and `settings`.
2. Add `vim.lsp.enable('<server_name>')` to `lua/config/lsp.lua`.

## Adding a New Plugin

1. Add an entry to `lua/config/plugins.lua` via `vim.pack.add`.
2. Plugins install to `~/.local/share/nvim/site/pack/core/opt/` on first launch.
3. The `nvim-pack-lock.json` lockfile is updated automatically.

### vim.pack.add() API Reference

Docs: https://neovim.io/doc/user/pack/#vim.pack.add()

**Signature:** `vim.pack.add({specs}, {opts})`

**Spec fields:**
- `src` (string, required) — Git URI (any format `git clone` supports)
- `name` (string, optional) — Directory name, defaults to repo name
- `version` (string|vim.VersionRange, optional) — Branch, tag, commit hash, or `vim.version.range()` for semver
- `data` (any, optional) — Arbitrary data associated with a plugin

**Options:**
- `load` (boolean|function, default: false during init.lua, true after) — Whether to load plugin files
- `confirm` (boolean, default: true) — Whether to ask user to confirm initial install

**Build/post-install hooks:** There is no `build` field. Use the `PackChanged` autocmd event instead:

```lua
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    -- ev.data fields: active, kind ("install"|"update"|"delete"), spec, path
    if ev.data.spec.name == 'my-plugin' and ev.data.kind == 'install' then
      -- run build step
    end
  end,
})
```

The `PackChanged` autocmd must be registered **before** `vim.pack.add()` is called so that it fires on initial install.

## Conventions

- **Plugins** → `lua/config/plugins.lua`
- **Colorscheme** → `lua/config/theme.lua`
- **Keymaps** → `lua/config/keymap.lua`
- **Options** → `lua/config/options.lua`
- **Autocommands** → `lua/config/autocmd.lua`
- **GitHub links** → `lua/config/gitlink.lua`
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
