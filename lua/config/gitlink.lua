local M = {}

local function git(cmd)
  local result = vim.trim(vim.fn.system(cmd))
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return result
end

local function parse_github_remote(url)
  local owner, repo = url:match('git@github%.com:([^/]+)/(.+)')
  if not owner then
    owner, repo = url:match('github%.com/([^/]+)/(.+)')
  end
  if not owner then
    return nil, nil
  end
  repo = repo:gsub('%.git$', '')
  return owner, repo
end

function M.get_github_link(line1, line2)
  local root = git('git rev-parse --show-toplevel')
  if not root then
    vim.notify('Not a git repository', vim.log.levels.WARN)
    return
  end

  local remote_url = git('git remote get-url origin')
  if not remote_url then
    vim.notify('No git remote "origin" configured', vim.log.levels.WARN)
    return
  end

  local owner, repo = parse_github_remote(remote_url)
  if not owner then
    vim.notify('Remote is not a GitHub URL: ' .. remote_url, vim.log.levels.WARN)
    return
  end

  local commit = git('git rev-parse HEAD')
  if not commit then
    vim.notify('Could not determine current commit', vim.log.levels.WARN)
    return
  end

  local file = vim.api.nvim_buf_get_name(0)
  local rel = file:sub(#root + 2)

  local anchor = (line1 == line2) and ('#L' .. line1) or ('#L' .. line1 .. '-L' .. line2)
  local url = string.format('https://github.com/%s/%s/blob/%s/%s%s', owner, repo, commit, rel, anchor)

  vim.fn.setreg('+', url)
  vim.notify(url, vim.log.levels.INFO)
end

vim.keymap.set('n', '<leader>gy', function()
  local line = vim.fn.line('.')
  M.get_github_link(line, line)
end, { desc = 'Copy GitHub link to clipboard' })

vim.keymap.set('x', '<leader>gy', function()
  vim.cmd('normal! \27')
  local line1 = vim.fn.line("'<")
  local line2 = vim.fn.line("'>")
  M.get_github_link(line1, line2)
end, { desc = 'Copy GitHub link to clipboard (selection)' })

return M
