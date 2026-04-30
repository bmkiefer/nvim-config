-- neo-tree
--------------------------------------------------------------------------------
require('neo-tree').setup({
  close_if_last_window = true,
  filesystem = {
    follow_current_file = { enabled = true },
    hijack_netrw_behavior = 'open_current',
  },
  window = {
    position = 'left',
    width = 35,
    mappings = {
      ['/'] = 'noop',
    },
  },
})
