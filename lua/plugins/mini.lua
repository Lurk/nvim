-- Collection of various small independent plugins/modules
return {
  'nvim-mini/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'
    -- set use_icons to true if you have a Nerd Font
    statusline.setup { use_icons = true }

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
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

    -- highlight trailing space
    require('mini.trailspace').setup()

    require('mini.jump2d').setup()

    local hipatterns = require 'mini.hipatterns'
    hipatterns.setup {
      highlighters = {
        -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
        fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
        hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
        todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
        note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = hipatterns.gen_highlighter.hex_color(),
      },
    }

    require('mini.cursorword').setup()

    require('mini.pairs').setup {
      -- In which modes mappings from this `config` should be created
      modes = { insert = true, command = false, terminal = false },

      -- Global mappings. Each right hand side should be a pair information, a
      -- table with at least these fields (see more in |MiniPairs.map|):
      -- - <action> - one of 'open', 'close', 'closeopen'.
      -- - <pair> - two character string for pair to be used.
      -- By default pair is not inserted after `\`, quotes are not recognized by
      -- <CR>, `'` does not insert pair after a letter.
      -- Only parts of tables can be tweaked (others will use these defaults).
      mappings = {
        ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
        ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
        ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },

        [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
        [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
        ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

        ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
        -- commented due Rust's lifetime syntax
        -- TODO: make it configurable per filetype
        -- ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
        ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
      },
    }

    require('mini.operators').setup()

    require('mini.completion').setup()

    require('mini.diff').setup()

    local miniclue = require 'mini.clue'
    miniclue.setup {
      triggers = {
        -- Leader triggers
        { mode = 'n', keys = '<Leader>' },
        { mode = 'x', keys = '<Leader>' },

        -- Built-in completion
        { mode = 'i', keys = '<C-x>' },

        -- `g` key
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },

        -- Marks
        { mode = 'n', keys = "'" },
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = "'" },
        { mode = 'x', keys = '`' },

        -- Registers
        { mode = 'n', keys = '"' },
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },

        -- Window commands
        { mode = 'n', keys = '<C-w>' },

        -- `z` key
        { mode = 'n', keys = 'z' },
        { mode = 'x', keys = 'z' },
      },

      clues = {
        -- Enhance this by adding descriptions for <Leader> mapping groups
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
      },
      -- Clue window settings
      window = {
        -- Floating window config
        config = {
          width = 'auto',
        },

        -- Delay before showing clue window
        delay = 300,

        -- Keys to scroll inside the clue window
        scroll_down = '<C-d>',
        scroll_up = '<C-u>',
      },
    }
  end,
}
