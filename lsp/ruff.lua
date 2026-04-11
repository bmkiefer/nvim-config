return {
  -- Command to start the ruff LSP server.
  cmd = { 'ruff', 'server' },

  -- Filetypes to automatically attach to.
  filetypes = { 'python' },

  -- Root directory markers for Python projects.
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },

  -- Match pyrefly's position encoding to avoid cross-client warnings.
  capabilities = {
    general = {
      positionEncodings = { 'utf-16' },
    },
  },
}
