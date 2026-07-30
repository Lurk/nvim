local M = {}

function M.setup()
  require('mini.ai').setup { n_lines = 500 }
  require('mini.surround').setup()

  local statusline = require 'mini.statusline'
  statusline.setup { use_icons = true }

  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_location = function()
    return '%2l:%-2v'
  end

  require('mini.move').setup {
    mappings = {
      down = '<S-Down>',
      up = '<S-Up>',
      line_down = '<S-Down>',
      line_up = '<S-Up>',
    },
  }

  require('mini.trailspace').setup()

  local hipatterns = require 'mini.hipatterns'
  hipatterns.setup {
    highlighters = {
      fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
      hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
      todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
      note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  }

  local minidiff = require 'mini.diff'
  minidiff.setup()

  local diff_vs_branch = function(base)
    local bufnr = vim.api.nvim_get_current_buf()
    local filepath = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
    if vim.v.shell_error ~= 0 then
      vim.notify('mini.diff: not a git repo', vim.log.levels.WARN)
      return
    end
    local relpath = filepath:sub(#root + 2)
    local ref_lines = vim.fn.systemlist({ 'git', 'show', base .. ':' .. relpath })
    if vim.v.shell_error ~= 0 then
      vim.notify('mini.diff: could not read ' .. relpath .. ' from ' .. base, vim.log.levels.WARN)
      return
    end
    minidiff.set_ref_text(bufnr, table.concat(ref_lines, '\n') .. '\n')
    minidiff.toggle_overlay(bufnr)
  end

  vim.keymap.set('n', '<leader>gd', function()
    diff_vs_branch 'main'
  end, { desc = '[g]it [d]iff vs main' })

  vim.keymap.set('n', '<leader>gD', function()
    local base = vim.fn.input('Diff vs branch: ')
    if base == '' then
      return
    end
    diff_vs_branch(base)
  end, { desc = '[g]it [D]iff vs [b]ranch' })

  require('mini.cursorword').setup()
  require('mini.pairs').setup()
  require('mini.operators').setup()
  require('mini.completion').setup()
  require('mini.icons').setup()
  ---@diagnostic disable-next-line: undefined-global
  MiniIcons.mock_nvim_web_devicons()

  local miniclue = require 'mini.clue'
  miniclue.setup {
    triggers = {
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },
      { mode = 'i', keys = '<C-x>' },
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' },
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },
    clues = {
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
    window = {
      config = {
        width = 'auto',
      },
      delay = 300,
      scroll_down = '<C-d>',
      scroll_up = '<C-u>',
    },
  }
end

return M
