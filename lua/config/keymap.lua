-- keymap
--------------------------------------------------------------------------------
local gitlink = require('config.gitlink')

local COMMENT_AUTHOR = 'bmkiefer'
local COMMENT_DATE_FORMAT = '%m-%d-%Y'

-- Navigate visual lines
vim.keymap.set({ 'n', 'x' }, 'j', 'gj', { desc = 'Navigate down (visual line)' })
vim.keymap.set({ 'n', 'x' }, 'k', 'gk', { desc = 'Navigate up (visual line)' })
vim.keymap.set({ 'n', 'x' }, '<Down>', 'gj', { desc = 'Navigate down (visual line)' })
vim.keymap.set({ 'n', 'x' }, '<Up>', 'gk', { desc = 'Navigate up (visual line)' })
vim.keymap.set('i', '<Down>', '<C-\\><C-o>gj', { desc = 'Navigate down (visual line)' })
vim.keymap.set('i', '<Up>', '<C-\\><C-o>gk', { desc = 'Navigate up (visual line)' })

-- Move Lines
vim.keymap.set({ 'n', 'x' }, '<M-S-Up>', ':move -2<cr>', { desc = 'Move Line Up' })
vim.keymap.set({ 'n', 'x' }, '<M-S-Down>', ':move +1<cr>', { desc = 'Move Line Down' })
vim.keymap.set('i', '<M-S-Up>', '<C-o>:move -2<cr>', { desc = 'Move Line Up' })
vim.keymap.set('i', '<M-S-Down>', '<C-o>:move +1<cr>', { desc = 'Move Line Down' })

-- Easier interaction with the system clipboard
vim.keymap.set({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set({ 'n', 'x' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard after the cursor position' })
vim.keymap.set({ 'n', 'x' }, '<leader>P', '"+P', { desc = 'Paste from system clipboard before the cursor position' })

-- Navigating buffers
vim.keymap.set('n', '<leader>bb', '<C-^>', { desc = 'Switch to alternate buffer' })
vim.keymap.set('n', '<leader>bn', ':bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bp', ':bprevious<cr>', { desc = 'Previous buffer' })

-- Ctrl-L redraws the screen by default. Now it will also toggle search highlighting.
vim.keymap.set('n', '<C-l>', ':set hlsearch!<cr><C-l>', { desc = 'Toggle search highlighting' })

-- Toggle visible whitespace characters
vim.keymap.set('n', '<leader>l', ':listchars!<cr>', { desc = 'Toggle [l]istchars' })

-- Neo-tree
vim.keymap.set('n', '\\', ':Neotree toggle<cr>', { desc = 'Toggle Neo-tree' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Quickly source current file / execute Lua code
vim.keymap.set('n', '<leader>xx', '<Cmd>source %<CR>', { desc = 'Source current file' })
vim.keymap.set('n', '<leader>x', '<Cmd>:.lua<CR>', { desc = 'Lua: execute current line' })
vim.keymap.set('v', '<leader>x', '<Cmd>:lua<CR>', { desc = 'Lua: execute current selection' })

-- Insert NOTE/TODO comments on a new line above the cursor using the buffer's commentstring
local function insert_tagged_comment(tag)
  local date = os.date(COMMENT_DATE_FORMAT)
  local prefix = string.format('%s(%s %s): ', tag, COMMENT_AUTHOR, date)
  local comment = vim.bo.commentstring:gsub('%%s', prefix)
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local current_line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ''
  local indent = current_line:match('^%s*') or ''
  vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { indent .. comment })
  vim.api.nvim_win_set_cursor(0, { row, 0 })
  vim.cmd('startinsert!')
end

vim.keymap.set('n', '<leader>in', function()
  insert_tagged_comment('NOTE')
end, { desc = 'Insert NOTE comment above' })

vim.keymap.set('n', '<leader>it', function()
  insert_tagged_comment('TODO')
end, { desc = 'Insert TODO comment above' })

-- GitHub permalinks
vim.keymap.set('n', '<leader>gy', function()
  local line = vim.fn.line('.')
  gitlink.get_github_link(line, line)
end, { desc = 'Copy GitHub link to clipboard' })

vim.keymap.set('x', '<leader>gy', function()
  vim.cmd('normal! \27')
  local line1 = vim.fn.line("'<")
  local line2 = vim.fn.line("'>")
  gitlink.get_github_link(line1, line2)
end, { desc = 'Copy GitHub link to clipboard (selection)' })
