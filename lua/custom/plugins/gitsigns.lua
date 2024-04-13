return {
  'lewis6991/gitsigns.nvim',
  opts = {
    on_attach = function()
      local gitsigns = require 'gitsigns'
      vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk, { desc = '[G]it [p]review hunk' })
      vim.keymap.set('n', '<leader>gb', function()
        gitsigns.blame_line { full = true }
      end, { desc = '[G]it [b]lame line' })
    end,
  },
}
