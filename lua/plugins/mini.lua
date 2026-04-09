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
