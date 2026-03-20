return {
  -- Command to start the pyrefly LSP server.
  cmd = { 'pyrefly', 'lsp' },

  -- Filetypes to automatically attach to.
  filetypes = { 'python' },

  -- Root directory markers for Python projects.
  root_markers = { 'pyrefly.toml', 'pyproject.toml', 'setup.py', 'setup.cfg', '.git' },
}
