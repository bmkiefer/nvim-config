vim.cmd.colorscheme('catppuccin-mocha')

-- Underline the current line instead of highlighting it
vim.api.nvim_set_hl(0, 'CursorLine', { underline = true, bg = 'NONE' })
