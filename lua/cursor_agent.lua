local M = {}

local agent_buf = nil
local agent_win = nil
local agent_mode = nil

local function is_valid_buf(buf)
  return buf and vim.api.nvim_buf_is_valid(buf)
end

local function is_valid_win(win)
  return win and vim.api.nvim_win_is_valid(win)
end

local function buf_visible(buf)
  if not is_valid_buf(buf) then
    return false
  end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_buf(win) == buf then
      return true
    end
  end
  return false
end

local function get_workspace()
  local root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  if vim.v.shell_error == 0 and root and root ~= '' then
    return root
  end
  return vim.fn.getcwd()
end

local function kill_agent()
  if is_valid_buf(agent_buf) then
    local job_id = vim.b[agent_buf].terminal_job_id
    if job_id then
      vim.fn.jobstop(job_id)
    end
    vim.api.nvim_buf_delete(agent_buf, { force = true })
  end
  agent_buf = nil
  agent_win = nil
  agent_mode = nil
end

local function ensure_right_split()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  if #wins < 2 then
    vim.cmd 'vsplit'
  else
    vim.cmd 'wincmd l'
  end
  return vim.api.nvim_get_current_win()
end

local function open_agent(mode)
  -- Already running in the requested mode — just focus
  if is_valid_buf(agent_buf) and agent_mode == mode then
    if buf_visible(agent_buf) then
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_buf(win) == agent_buf then
          vim.api.nvim_set_current_win(win)
          vim.cmd 'startinsert'
          return
        end
      end
    else
      agent_win = ensure_right_split()
      vim.api.nvim_win_set_buf(agent_win, agent_buf)
      vim.cmd 'startinsert'
      return
    end
  end

  kill_agent()

  agent_win = ensure_right_split()

  local cmd = { 'cursor-agent', '--workspace', get_workspace() }
  if mode == 'plan' then
    table.insert(cmd, '--plan')
  end

  vim.cmd 'enew'
  vim.fn.termopen(cmd)
  agent_buf = vim.api.nvim_get_current_buf()
  agent_mode = mode

  vim.api.nvim_create_autocmd('BufWipeout', {
    buffer = agent_buf,
    once = true,
    callback = function()
      agent_buf = nil
      agent_win = nil
      agent_mode = nil
    end,
  })

  vim.cmd 'startinsert'
end

function M.plan()
  open_agent 'plan'
end

function M.build()
  open_agent 'build'
end

function M.setup()
  vim.keymap.set('n', '<leader>cp', M.plan, { desc = 'Cursor Plan' })
  vim.keymap.set('n', '<leader>cb', M.build, { desc = 'Cursor Build' })
end

return M
