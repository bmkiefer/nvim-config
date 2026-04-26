local function git(cmd)
  local result = vim.trim(vim.fn.system(cmd))
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return result
end

local function fail(msg)
  vim.notify(msg, vim.log.levels.WARN)
  return nil
end

local remote_patterns = {
  'git@github%.com:([^/]+)/(.+)',
  'github%.com/([^/]+)/(.+)',
}

local function parse_github_remote(url)
  for _, pattern in ipairs(remote_patterns) do
    local owner, repo = url:match(pattern)
    if owner then
      return owner, (repo:gsub('%.git$', ''))
    end
  end
  return nil, nil
end

local function format_anchor(line1, line2)
  if line1 == line2 then
    return '#L' .. line1
  end
  return '#L' .. line1 .. '-L' .. line2
end

local function get_github_link(line1, line2)
  local root = git('git rev-parse --show-toplevel') or fail('Not a git repository')
  if not root then
    return
  end

  local remote_url = git('git remote get-url origin') or fail('No git remote "origin" configured')
  if not remote_url then
    return
  end

  local owner, repo = parse_github_remote(remote_url)
  if not owner then
    return fail('Remote is not a GitHub URL: ' .. remote_url)
  end

  local commit = git('git rev-parse HEAD') or fail('Could not determine current commit')
  if not commit then
    return
  end

  local file = vim.api.nvim_buf_get_name(0)
  local rel_path = file:sub(#root + 2)
  local url = string.format('https://github.com/%s/%s/blob/%s/%s%s', owner, repo, commit, rel_path, format_anchor(line1, line2))

  vim.fn.setreg('+', url)
  vim.notify(url, vim.log.levels.INFO)
end

return {
  get_github_link = get_github_link,
}
