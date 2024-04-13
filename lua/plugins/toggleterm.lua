return {
  'akinsho/toggleterm.nvim',
  config = true,
  init = function()
    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new { cmd = 'lazygit', hidden = true }

    local function lazygit_toggle()
      lazygit:toggle()
    end

    vim.keymap.set({ 'n', 't', 'i' }, '<F7>', '<cmd>ToggleTerm<cr>', { desc = 'Toggle [t]erminal' })
    vim.keymap.set('n', '<leader>gg', lazygit_toggle, { desc = 'lazy[G]it' })
  end,
  opts = {
    shading_factor = 2,
    open_mapping = [[<c-\>]],
    direction = 'float',
    float_opts = { border = 'rounded' },
    size = 10,
    on_create = function(t)
      vim.opt_local.foldcolumn = '0'
      vim.opt_local.signcolumn = 'no'
      if t.hidden then
        local toggle = function()
          t:toggle()
        end
      end
    end,
  },
}
