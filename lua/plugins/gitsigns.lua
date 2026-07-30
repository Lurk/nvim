local M = {}

function M.setup()
  require('gitsigns').setup {
    on_attach = function()
      local gitsigns = require 'gitsigns'
      vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk, { desc = '[g]it [p]review hunk' })
      vim.keymap.set('n', '<leader>gb', function()
        gitsigns.blame_line { full = true }
      end, { desc = '[g]it [b]lame line' })
    end,
  }
end

return M
