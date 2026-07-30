local M = {}

function M.setup()
  require('toggleterm').setup {
    shading_factor = 2,
    open_mapping = [[<c-\>]],
    direction = 'float',
    float_opts = { border = 'rounded' },
    size = 10,
    on_create = function(t)
      vim.opt_local.foldcolumn = '0'
      vim.opt_local.signcolumn = 'no'
    end,
  }

  local Terminal = require('toggleterm.terminal').Terminal
  local lazygit = Terminal:new { cmd = 'lazygit', hidden = true }

  vim.keymap.set({ 'n', 't', 'i' }, '<F7>', '<cmd>ToggleTerm<cr>', { desc = 'Toggle [t]erminal' })
  vim.keymap.set('n', '<leader>gg', function()
    lazygit:toggle()
  end, { desc = 'lazy[g]it' })
end

return M
