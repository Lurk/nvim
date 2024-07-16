return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    require('which-key').add {
      { '<leader>c', group = '[C]ode' },
      { '<leader>c_', hidden = true },
      { '<leader>d', group = '[D]debug' },
      { '<leader>d_', hidden = true },
      { '<leader>g', group = '[G]it' },
      { '<leader>g_', hidden = true },
      { '<leader>r', group = '[R]un' },
      { '<leader>r_', hidden = true },
      { '<leader>s', group = '[S]earch' },
      { '<leader>s_', hidden = true },
    }
  end,
  opts = {},
}
